import 'dart:async';
import 'dart:io';
import 'package:ezygut/core/service/api_service.dart';
import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/core/service/socket_service.dart';
import 'package:ezygut/core/service/storage_service.dart';
import 'package:ezygut/feature/patient/chat/models/chat_list_model.dart';
import 'package:ezygut/feature/patient/chat/models/message_model.dart';
import 'package:ezygut/share/widgets/custom_snack_bar/custom_snack_bar.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  // ── Context ──
  BuildContext? _chatContext;

  // ─────────────────────────────────────────────────────────────────────────
  // CHAT LIST
  // ─────────────────────────────────────────────────────────────────────────
  final RxList<ChatListModel> userChatList = <ChatListModel>[].obs;
  final RxBool isLoadingChatList = false.obs;
  final TextEditingController messageTextController = TextEditingController();
  final ScrollController scrollListController = ScrollController();

  // ── Search ──
  final RxString chatSearchQuery = ''.obs;
  Timer? _chatSearchDebounce;

  void onChatSearch(String query) {
    chatSearchQuery(query);
    if (_chatSearchDebounce?.isActive ?? false) _chatSearchDebounce!.cancel();
    _chatSearchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (_chatContext != null) {
        fetchConversationList(context: _chatContext!);
      }
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  Future<void> initChatList({required BuildContext context}) async {
    _chatContext = context;
    await fetchConversationList(context: context);
    await _ensureSocketReady(context: context);
    _ensureMessageListener();
  }

  // ─────────────────────────────────────────────────────────────────────────
  Future<void> fetchConversationList({required BuildContext context}) async {
    _chatContext = context;
    isLoadingChatList(true);

    final String search = chatSearchQuery.value.trim();
    final String url = search.isNotEmpty
        ? '${ApiUrl.conversationList}?search=$search'
        : ApiUrl.conversationList;

    final response = await ApiService.getData(url);

    if (response.statusCode == 200) {
      final List data = response.body['data'] ?? [];
      userChatList.value =
          data.map((e) => ChatListModel.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      CustomSnackbar.error(
         // context: context,
          message: "Session expired. Please login again.");
    } else {
      userChatList.clear();
    }

    isLoadingChatList(false);
  }

  Future<void> _ensureSocketReady({BuildContext? context}) async {
    if (context != null) _chatContext = context;
    await AppSocket.syncUserSession();
    if (!AppSocket.isConnected) {
      await AppSocket.init(
        onSocketConnect: _ensureMessageListener,
      );
    }
  }

  /// Single socket listener for both chat list + detail screen.
  void _ensureMessageListener() {
    AppSocket.listenNewMessages((data) {
      final payload = _normalizeMessagePayload(data);
      final convId = payload['conversationId']?.toString();
      if (convId == null || convId.isEmpty) {
        if (_chatContext != null) {
          fetchConversationList(context: _chatContext!);
        }
        return;
      }

      debugPrint('📩 Socket message received: $convId');

      updateChatList(payload, convId, _chatContext);

      if (convId == conversationId) {
        onNewMessage(payload);
      }
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  void updateChatList(dynamic data, String convId, BuildContext? context) {
    final index =
    userChatList.indexWhere((c) => c.conversationId == convId);
    final isCurrentConversation = convId == conversationId;

    if (index != -1) {
      final existing = userChatList[index];

      final updated = ChatListModel(
        conversationId: existing.conversationId,
        participant: existing.participant,
        lastMessage: LastMessage(
          content: data['content'] ?? '',
          messageType: data['messageType'] ?? 'text',
          createdAt: data['createdAt'],
          isDeleted: data['isDeleted'] ?? false,
        ),
        lastMessageAt: data['createdAt'] ?? existing.lastMessageAt,
        unreadCount: isCurrentConversation
            ? 0
            : (existing.unreadCount ?? 0) + 1,
      );

      final newList = List<ChatListModel>.from(userChatList);
      newList.removeAt(index);
      newList.insert(0, updated);
      userChatList.assignAll(newList);

      debugPrint('✅ Chat list updated & moved to top: $convId');
    } else if (context != null) {
      fetchConversationList(context: context);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CHAT DETAILS
  // ─────────────────────────────────────────────────────────────────────────
  final ScrollController scrollController = ScrollController();
  final RxBool isLoadingMessages = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isUploadingAttachment = false.obs;
  final RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;

  String? conversationId;
  String? receiverId;
  String? currentUserId;

  bool hasMoreMessages = true;
  int currentPage = 1;
  final int pageLimit = 15;

  bool _isLoadingMoreLock = false;
  bool _scrollAttached = false;

  // ─────────────────────────────────────────────────────────────────────────
  void _attachScroll() {
    if (_scrollAttached) return;
    _scrollAttached = true;
    scrollController.addListener(_onScroll);
  }

  // ─────────────────────────────────────────────────────────────────────────
  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (_isLoadingMoreLock) return;
    if (!hasMoreMessages) return;

    if (scrollController.position.extentAfter < 300) {
      _isLoadingMoreLock = true;
      loadMoreMessages();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  Future<void> initConversation({
    required String convId,
    required String recId,
    required BuildContext context,
  }) async {
    conversationId = convId;
    receiverId = recId;
    _chatContext = context;
    currentUserId = await SharePrefsHelper.getString(AppConst.userId);

    await _ensureSocketReady(context: context);
    _ensureMessageListener();

    AppSocket.joinConversation(convId);

    _attachScroll();
    await fetchMessages(context: context);
  }

  // ─────────────────────────────────────────────────────────────────────────
  Future<void> fetchMessages({required BuildContext context}) async {
    if (conversationId == null) return;

    isLoadingMessages(true);
    currentPage = 1;
    hasMoreMessages = true;
    _isLoadingMoreLock = false;
    messages.clear();

    final response = await ApiService.getData(
      ApiUrl.getMessage(
        conversationId: conversationId!,
        page: 1,
        limit: pageLimit,
      ),
    );

    if (response.statusCode == 200) {
      final data = response.body['data']['messages'] ?? [];
      messages.value = (data
          .map((e) => ChatMessageModel.fromJson(e))
          .toList()
          .cast<ChatMessageModel>())
          .reversed
          .toList();

      if (data.length < pageLimit) hasMoreMessages = false;
    }

    isLoadingMessages(false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  Future<void> loadMoreMessages() async {
    if (!hasMoreMessages || conversationId == null) {
      _isLoadingMoreLock = false;
      return;
    }

    isLoadingMore(true);
    final nextPage = currentPage + 1;

    final response = await ApiService.getData(
      ApiUrl.getMessage(
        conversationId: conversationId!,
        page: nextPage,
        limit: pageLimit,
      ),
    );

    if (response.statusCode == 200) {
      final data = response.body['data']['messages'] ?? [];

      if (data.isEmpty || data.length < pageLimit) {
        hasMoreMessages = false;
      }

      if (data.isNotEmpty) {
        final newMessages = (data
            .map((e) => ChatMessageModel.fromJson(e))
            .toList()
            .cast<ChatMessageModel>())
            .reversed
            .toList();
        messages.addAll(newMessages);
        currentPage = nextPage;
      }
    }

    isLoadingMore(false);
    _isLoadingMoreLock = false;
  }

  // ─────────────────────────────────────────────────────────────────────────
  void _scrollToBottom() {
    if (!scrollController.hasClients) return;
    scrollController.jumpTo(0.0);
  }

  // ─────────────────────────────────────────────────────────────────────────
  void onNewMessage(dynamic data) {
    if (data is! Map<String, dynamic>) return;
    final convId = data['conversationId']?.toString();
    if (convId == null || convId.isEmpty) return;

    final newMessage = ChatMessageModel.fromJson(
      Map<String, dynamic>.from(data),
    );

    if (newMessage.conversationId != conversationId) return;

    final tempId = data['tempId']?.toString();

    // Replace optimistic temp message with the confirmed server message.
    if (tempId != null && tempId.isNotEmpty) {
      final tempIndex = messages.indexWhere((m) => m.id == tempId);
      if (tempIndex != -1) {
        messages[tempIndex] = newMessage;
        messages.refresh();
        _scrollToBottom();
        return;
      }
    }

    if (messages.any((m) => m.id == newMessage.id)) return;

    // Fallback: replace a pending local message from the same sender.
    if (_isSameUser(newMessage.senderId, currentUserId)) {
      final pendingIndex = messages.indexWhere((m) =>
          _isPendingLocalId(m.id) &&
          _isSameUser(m.senderId, currentUserId) &&
          m.content == newMessage.content &&
          m.messageType == newMessage.messageType);
      if (pendingIndex != -1) {
        messages[pendingIndex] = newMessage;
        messages.refresh();
        _scrollToBottom();
        return;
      }
    }

    messages.insert(0, newMessage);
    _scrollToBottom();
  }

  bool _isPendingLocalId(String? id) {
    if (id == null || id.isEmpty) return false;
    return int.tryParse(id) != null;
  }

  bool _isSameUser(String? a, String? b) {
    if (a == null || b == null) return false;
    return a.trim() == b.trim();
  }

  Map<String, dynamic> _normalizeMessagePayload(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      final nested = raw['message'];
      if (nested is Map<String, dynamic>) return nested;
      return raw;
    }
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final nested = map['message'];
      if (nested is Map<String, dynamic>) return nested;
      if (nested is Map) return Map<String, dynamic>.from(nested);
      return map;
    }
    return {};
  }

  // ─────────────────────────────────────────────────────────────────────────
  Future<void> sendMessage({BuildContext? context}) async {
    if (selectedFile.value != null) {
      await _uploadAndSendAttachment(
        file: selectedFile.value!,
        messageType: selectedFileType.value,
        context: context!,
      );

      selectedFile.value = null;
      selectedFileName.value = '';
      selectedFileType.value = '';
      return;
    }

    final selectedRole =
    await SharePrefsHelper.getString(AppConst.selectedRole);
    currentUserId = await SharePrefsHelper.getString(AppConst.userId);
    final text = messageTextController.text.trim();
    if (text.isEmpty || conversationId == null) return;
    if (receiverId == null) {
      debugPrint('❌ receiverId is null');
      return;
    }

    await _ensureSocketReady(context: context);
    if (!AppSocket.isConnected) {
      debugPrint('❌ Socket not connected');
      return;
    }

    messageTextController.clear();

    final tempId =
    DateTime.now().millisecondsSinceEpoch.toString();

    final tempMsg = ChatMessageModel(
      id: tempId,
      conversationId: conversationId,
      senderId: currentUserId,
      content: text,
      messageType: 'text',
      senderRole: selectedRole,
      createdAt: DateTime.now().toIso8601String(),
      status: 'sent',
    );

    messages.insert(0, tempMsg);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    try {
      AppSocket.sendMessage(
        conversationId: conversationId!,
        receiverId: receiverId!,
        content: text,
        tempId: tempId,
        senderRole: selectedRole,
      );
      debugPrint('📤 Message sent: $text');

      updateChatList(
        {
          'content': text,
          'messageType': 'text',
          'createdAt': DateTime.now().toIso8601String(),
          'isDeleted': false,
        },
        conversationId!,
        context ?? _chatContext,
      );
    } catch (e) {
      debugPrint('❌ Socket send error: $e');
    }
  }

  final Rx<File?> selectedFile = Rx<File?>(null);
  final RxString selectedFileName = ''.obs;
  final RxString selectedFileType = ''.obs;

  Future<void> pickImage() async {
    try {
      final XFile? picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (picked == null) return;

      selectedFile.value = File(picked.path);
      selectedFileName.value = picked.name;
      selectedFileType.value = 'image';
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }


  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'zip', 'rar'],
      );

      if (result == null || result.files.single.path == null) return;

      final file = File(result.files.single.path!);
      final extension = result.files.single.extension?.toLowerCase() ?? '';

      selectedFile.value = file;
      selectedFileName.value = result.files.single.name;
      selectedFileType.value = extension == 'pdf' ? 'pdf' : 'file';
    } catch (e) {
      debugPrint("File pick error: $e");
    }
  }

  Future<void> pickAndSendFile({required BuildContext context}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'zip', 'rar'],
      );
      if (result == null || result.files.single.path == null) return;

      final file = File(result.files.single.path!);
      final extension = result.files.single.extension?.toLowerCase() ?? '';
      final messageType = extension == 'pdf' ? 'pdf' : 'file';

      await _uploadAndSendAttachment(
        file: file,
        messageType: messageType,
        context: context,
      );
    } catch (_) {
      CustomSnackbar.error(
        //context: context,
        message: 'File select failed. Please try again.',
      );
    }
  }

  Future<void> _uploadAndSendAttachment({
    required File file,
    required String messageType,
    required BuildContext context,
  }) async {
    if (conversationId == null || receiverId == null) return;

    await _ensureSocketReady(context: context);
    if (!AppSocket.isConnected) {
      CustomSnackbar.error(
        //context: context,
        message: 'Chat connection unavailable. Please try again.',
      );
      return;
    }

    final selectedRole = await SharePrefsHelper.getString(AppConst.selectedRole);
    currentUserId = await SharePrefsHelper.getString(AppConst.userId);
    final fileSize = await file.length();
    final fileName = file.path.split(RegExp(r'[\\/]+')).last;

    isUploadingAttachment(true);
    final uploadResponse = await ApiService.postMultipartData(
      ApiUrl.chatUpload,
      {},
      multipartBody: [MultipartBody('file', file)],
    );
    isUploadingAttachment(false);

    if (uploadResponse.statusCode != 200 && uploadResponse.statusCode != 201) {
      CustomSnackbar.error(
        //context: context,
        message: uploadResponse.body?['message'] ?? 'Upload failed. Please try again.',
      );
      return;
    }

    final body = uploadResponse.body ?? {};
    final data = body['data'] is Map ? Map<String, dynamic>.from(body['data']) : <String, dynamic>{};
    final fileUrl = (data['fileUrl'] ?? data['url'] ?? data['path'] ?? '').toString();
    if (fileUrl.isEmpty) {
      CustomSnackbar.error(
       // context: context,
        message: 'Upload succeeded but file url is missing.',
      );
      return;
    }

    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final tempMsg = ChatMessageModel(
      id: tempId,
      conversationId: conversationId,
      senderId: currentUserId,
      content: fileName,
      messageType: messageType,
      fileUrl: fileUrl,
      fileName: fileName,
      fileSize: fileSize,
      senderRole: selectedRole,
      createdAt: DateTime.now().toIso8601String(),
      status: 'sent',
    );
    messages.insert(0, tempMsg);
    _scrollToBottom();

    AppSocket.sendMessage(
      conversationId: conversationId!,
      receiverId: receiverId!,
      senderRole: selectedRole,
      content: fileName,
      messageType: messageType,
      fileUrl: fileUrl,
      fileName: fileName,
      fileSize: fileSize,
      tempId: tempId,
    );

    updateChatList(
      {
        'content': fileName,
        'messageType': messageType,
        'fileUrl': fileUrl,
        'fileName': fileName,
        'fileSize': fileSize,
        'createdAt': DateTime.now().toIso8601String(),
        'isDeleted': false,
      },
      conversationId!,
      context,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  Future<bool> markAsRead({required String conversationId}) async {
    try {
      final response = await ApiService.postData(
        ApiUrl.unread(conversationId: conversationId),
        {},
        isAuthRequired: true,
      );
      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  void onClose() {
    _chatSearchDebounce?.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    scrollListController.dispose();
    messageTextController.dispose();
    super.onClose();
  }
}
