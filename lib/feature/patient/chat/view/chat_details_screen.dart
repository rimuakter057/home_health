import 'package:ezygut/core/service/socket_service.dart';
import 'package:ezygut/core/service/storage_service.dart';
import 'package:ezygut/feature/patient/chat/controller/chat_controller.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/custom_profile/custom_profile_image.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:ezygut/utils/assets_path/assets_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../share/widgets/app_bar/custom_app_bar.dart';
import '../../../../../share/widgets/card/app_card.dart';
import '../../../../../share/widgets/custom_image/custom_image.dart';
import '../../../../../utils/color/app_colors.dart';
import '../../../../../utils/extension/base_extension.dart';
import '../widget/chat_bubble_widget.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({
    super.key,
    required this.conversationId,
    required this.receiverId,
    required this.receiverName,
    this.image,

  });

  final String conversationId;
  final String receiverId;
  final String receiverName;
  final String?image;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final controller = Get.find<ChatController>();

  String userId = '';
  String selectedRole = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userId = await SharePrefsHelper.getString(AppConst.userId);
      selectedRole = await SharePrefsHelper.getString(AppConst.selectedRole);

      await AppSocket.init();

      controller.initConversation(
        convId: widget.conversationId,
        recId: widget.receiverId,
        context: context,
      );
    });
  }

  @override
  void dispose() {
    controller.messages.clear();
    controller.conversationId = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: const CustomAppBar(title: "Messages"),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.maxContentWidth,
          ),
          padding: ResponsiveHelper.all(16),
          child: AppCard(
            child: Column(
              children: [
                /// 👤 Header
                Row(
                  children: [
                     CustomProfileAvatar(
                       image:widget.image??AppConst.unknown ,
                     ),
                    SizedBox(width: ResponsiveHelper.spacing(12)),
                    Text(
                      widget.receiverName,
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: ResponsiveHelper.fontSize(16),
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.spacing(6)),
                    // Icon(
                    //   Icons.circle,
                    //   size: ResponsiveHelper.iconSize(10),
                    //   color: AppColors.green,
                    // ),
                  ],
                ),

                Divider(height: ResponsiveHelper.spacing(24)),

                /// 💬 Chat Messages
                Expanded(
                  child: Obx(() {
                    if (controller.isLoadingMessages.value) {
                      return const _ChatMessagesShimmer();
                    }

                    if (controller.messages.isEmpty) {
                      return Center(
                        child: Text(
                          'No messages yet.\nSay hello! 👋',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(14),
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: controller.scrollController,
                      reverse: true,
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveHelper.spacing(8),
                      ),

                      itemCount:
                          controller.messages.length +
                          (controller.isLoadingMore.value ? 1 : 0),

                      itemBuilder: (context, index) {
                        // loader at top (reverse:true)
                        if (controller.isLoadingMore.value &&
                            index == controller.messages.length) {
                          return const Padding(
                            padding: EdgeInsets.all(12),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final message = controller.messages[index];
                        debugPrint('MSG → type: ${message.messageType}, url: ${message.fileUrl}');
                        final senderId = message.senderId?.trim() ?? '';
                        final myId = controller.currentUserId?.trim() ?? '';
                        final isMe =
                            senderId.isNotEmpty &&
                            myId.isNotEmpty &&
                            senderId == myId;

                        final bubbleText = message.isDeleted == true
                            ? "This message was deleted"
                            : _resolveBubbleText(message);

                        return ChatBubble(
                          isMe: isMe,
                          message: bubbleText,
                          messageType: message.messageType ?? 'text',  // ✅ add
                          fileUrl: message.fileUrl,                    // ✅ add
                          fileName: message.fileName,                  // ✅ add
                        );
                      },
                    );
                  }),
                ),

                /// ✏ Input Field Section
                Padding(
                  padding: ResponsiveHelper.symmetric(vertical: 8),
                  child: Column(
                    children: [

                      Obx(() {
                        if (controller.selectedFile.value == null) {
                          return const SizedBox();
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.attach_file),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  controller.selectedFileName.value,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.selectedFile.value = null;
                                  controller.selectedFileName.value = '';
                                  controller.selectedFileType.value = '';
                                },
                                child: const Icon(Icons.close),
                              )
                            ],
                          ),
                        );
                      }),







                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => controller.pickFile(),
                            child: Icon(
                              Icons.attach_file,
                              color: AppColors.primaryColor,
                              size: ResponsiveHelper.iconSize(24),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(8)),
                          Obx(() {
                            if (controller.isUploadingAttachment.value) {
                              return SizedBox(
                                width: ResponsiveHelper.iconSize(24),
                                height: ResponsiveHelper.iconSize(24),
                                child: const CircularProgressIndicator(strokeWidth: 2),
                              );
                            }
                            return GestureDetector(
                              onTap: () => controller.pickImage(),
                              child: Icon(
                                Icons.image_outlined,
                                color: AppColors.primaryColor,
                                size: ResponsiveHelper.iconSize(24),
                              ),
                            );
                          }),
                          SizedBox(width: ResponsiveHelper.spacing(8)),

                          Expanded(
                            child: Container(
                              constraints: BoxConstraints(
                                minHeight: ResponsiveHelper.height(44),
                                maxHeight: ResponsiveHelper.height(120),
                              ),
                              padding: ResponsiveHelper.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.borderRadius(8),
                                ),
                                border: Border.all(color: Colors.white, width: 1),
                              ),
                              child: TextField(
                                controller: controller.messageTextController,
                                minLines: 1,
                                maxLines: 5,
                                textInputAction: TextInputAction.newline,
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: ResponsiveHelper.fontSize(14),
                                ),
                                cursorColor: AppColors.primaryColor,
                                decoration: InputDecoration(
                                  hintText: "Type a message...",
                                  hintStyle: TextStyle(
                                    color: AppColors.text2,
                                    fontSize: ResponsiveHelper.fontSize(14),
                                  ),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: ResponsiveHelper.spacing(8)),
                          GestureDetector(
                            onTap: () => controller.sendMessage(context: context),
                            child: Container(
                              padding: ResponsiveHelper.all(8),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryColor,
                              ),
                              child: CustomImage(
                                imageSrc: AssetsPath.sendPng,
                                imageColor: AppColors.white,
                                height: ResponsiveHelper.height(18),
                                width: ResponsiveHelper.width(18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _resolveBubbleText(dynamic message) {
    final type = (message.messageType ?? 'text').toLowerCase();
    if (type == 'image') {
      return "Image: ${message.fileName ?? message.content ?? 'Attachment'}";
    }
    if (type == 'pdf') {
      return "PDF: ${message.fileName ?? message.content ?? 'Attachment'}";
    }
    if (type == 'file') {
      return "File: ${message.fileName ?? message.content ?? 'Attachment'}";
    }
    return message.content ?? "";
  }
}


///chat message shimmer========


class _ChatMessagesShimmer extends StatefulWidget {
  const _ChatMessagesShimmer();

  @override
  State<_ChatMessagesShimmer> createState() => _ChatMessagesShimmerState();
}

class _ChatMessagesShimmerState extends State<_ChatMessagesShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _anim = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _box({required double w, required double h, double radius = 8}) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value + 1, 0),
            colors: [
              Colors.grey.shade300,
              Colors.grey.shade100,
              Colors.grey.shade300,
            ],
          ),
        ),
      ),
    );
  }

  /// isMe=true  → right align (sent)
  /// isMe=false → left align (received)
  Widget _bubble(double sw, {required bool isMe}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.spacing(5),
      ),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: _box(
          w: sw * 0.5,
          h: ResponsiveHelper.height(30),
          radius: 16,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    /// বিভিন্ন width দিয়ে natural chat look
    final bubbles = [
      false, true, false, true, true,
      false, true, false, true, false,
    ];

    return ListView.builder(
      reverse: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.spacing(8),
      ),
      itemCount: bubbles.length,
      itemBuilder: (_, i) => _bubble(sw, isMe: bubbles[i]),
    );
  }
}