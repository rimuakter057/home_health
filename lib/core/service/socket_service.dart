
import 'dart:async';

import 'package:ezygut/core/service/storage_service.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:ezygut/utils/string/app_string.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'api_url.dart';


class AppSocket {
  factory AppSocket() => _instance;
  AppSocket._internal();

  static final AppSocket _instance = AppSocket._internal();
  static io.Socket? socket;
  static bool _isInitialized = false;
  static bool _isConnecting = false;
  static Completer<void>? _connectCompleter;
  static Function? _onSocketConnectCallback;
  static String? _userId;

  static bool get isConnected => socket?.connected ?? false;

  ///<------------------ Public Init ------------------>
  static Future<void> init({Function? onSocketConnect}) async {
    _onSocketConnectCallback = onSocketConnect;

    final latestUserId = await SharePrefsHelper.getString(AppConst.userId);
    if (latestUserId == null ||
        latestUserId.isEmpty ||
        latestUserId == 'null') {
      debugPrint('⚠️ No userId found. Socket not connecting.');
      return;
    }

    // Reconnect when a different user logs in on the same session.
    if (isConnected && _userId != null && _userId != latestUserId) {
      debugPrint('🔄 User changed ($_userId → $latestUserId). Reconnecting socket.');
      dispose();
    }

    _userId = latestUserId;

    if (isConnected) {
      emitUsersOnline();
      _onSocketConnectCallback?.call();
      return;
    }

    if (_isConnecting) {
      await _connectCompleter?.future;
      return;
    }

    _isConnecting = true;
    _connectCompleter = Completer<void>();
    _connectToSocket();
    _isInitialized = true;

    try {
      await _connectCompleter!.future.timeout(const Duration(seconds: 8));
    } catch (_) {
      debugPrint('⚠️ Socket connect timeout');
    } finally {
      _isConnecting = false;
      _connectCompleter = null;
    }
  }

  /// Keeps socket user in sync with SharedPreferences (call after login).
  static Future<void> syncUserSession() async {
    await init();
  }

  ///<------------------ Internal Connect ------------------>
  static void _connectToSocket() {
    final socketUrl = ApiUrl.baseSocketUrl;

    socket = io.io(
      socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .build(),
    );

    _registerListeners();
  }

  ///<------------------ Register Events ------------------>
  static void _registerListeners() {
    if (socket == null) return;

    socket!
      ..onConnect((_) {
        debugPrint('✅ Socket connected as $_userId');

        // Step 2: Connect হলে সাথে সাথে users:online emit করো
        emitUsersOnline();

        _onSocketConnectCallback?.call();
        if (_connectCompleter != null && !_connectCompleter!.isCompleted) {
          _connectCompleter!.complete();
        }
      })
      ..onDisconnect((data) {
        debugPrint('🔌 Disconnected: $data');
      })
      ..onReconnectAttempt((attempt) {
        debugPrint('🔁 Reconnect attempt: $attempt');
      })
      ..onReconnectFailed((_) {
        debugPrint('❌ Reconnect failed');
      })
      ..onError((error) {
        debugPrint('⚠️ Socket error: $error');
        if (_connectCompleter != null && !_connectCompleter!.isCompleted) {
          _connectCompleter!.completeError(error ?? 'Socket connect error');
        }
      })
      ..on('unauthorized', (data) {
        debugPrint('❌ Unauthorized: $data');
      });
  }

  ///<------------------ Step 2: Users Online ------------------>
  static void emitUsersOnline() {
    if (_userId == null) return;
    sendEvent('users:online', {'userId': _userId});
    debugPrint('📡 Emitted users:online for $_userId');
  }

  ///<------------------ Step 5: Join Conversation ------------------>
  static void joinConversation(String conversationId) {
    sendEvent('conversation:join', {'conversationId': conversationId});
    debugPrint('🚪 Joined conversation: $conversationId');
  }

  ///<------------------ Step 6: Send Message ------------------>
  static void sendMessage({
    required String conversationId,
    required String receiverId,
    required String senderRole,
    required String content,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    String? tempId,
    String messageType = 'text',
  }) {
    if (_userId == null || _userId!.isEmpty) {
      debugPrint('❌ Cannot send message: userId is missing.');
      return;
    }

    final normalizedRole = senderRole.toLowerCase().trim();
    final receiverRole = normalizedRole == AppStrings.patient
        ? AppStrings.clinician
        : AppStrings.patient;

    // ❌ এই line টা delete করো:
    // String senderRole = AppConst.selectedRole;

    final payload = {
      "conversationId": conversationId,
      "senderId": _userId,
      "senderRole": normalizedRole,
      "receiverId": receiverId,
      "receiverRole": receiverRole, // ✅ "patient" হবে
      "content": content,
      "messageType": messageType,
      if (fileUrl != null) "fileUrl": fileUrl,
      if (fileName != null) "fileName": fileName,
      if (fileSize != null) "fileSize": fileSize,
      "tempId": tempId ?? "temp-${DateTime.now().millisecondsSinceEpoch}",
    };

    sendEvent('message:send', payload);
    debugPrint('📤 Message sent: $payload');
  }





 // ── Text Message ─────────────────────────────────────────────






//   static void sendMessage({
//     required String conversationId,
//     required String receiverId,
//     required String content,
//     String? tempId,
//     String messageType = 'text',
//   })
//   {
//     if (_userId == null) return;
//
//     String receiverRole = AppConst.selectedRole == AppStrings.patient
//         ? AppStrings.clinician
//         : AppStrings.patient;
//
//     final payload = {
//       "conversationId": conversationId,
//       "senderId": _userId,
//       "senderRole": AppConst.selectedRole,
//       "receiverId": receiverId,
//       "receiverRole": receiverRole,
//       "content": content,
//       "messageType": messageType,
//       "tempId": tempId ?? "temp-${DateTime.now().millisecondsSinceEpoch}",
//     };
//
//     sendEvent('message:send', payload);
//     debugPrint('📤 Message sent: $payload');
//   }
//
// // ── File / Image Message ──────────────────────────────────────
//   static void sendFileMessage({
//     required String conversationId,
//     required String receiverId,
//     required String messageType,
//     required String fileUrl,
//     required String fileName,
//     required int fileSize,
//     String? tempId,
//   })
//   {
//     if (_userId == null) return;
//
//     String receiverRole = AppConst.selectedRole == AppStrings.patient
//         ? AppStrings.clinician
//         : AppStrings.patient;
//
//     final payload = {
//       "conversationId": conversationId,
//       "senderId": _userId,
//       "senderRole": AppConst.selectedRole,
//       "receiverId": receiverId,
//       "receiverRole": receiverRole,
//       "content": fileName,       // ✅ fileName — static না
//       "messageType": messageType,
//       "fileUrl": fileUrl,
//       "fileName": fileName,
//       "fileSize": fileSize,
//       "tempId": tempId ?? "temp-${DateTime.now().millisecondsSinceEpoch}",
//     };
//
//     sendEvent('message:send', payload);
//     debugPrint('📤 File message sent: $payload');
//   }





  ///<------------------ Step 6: Listen New Message ------------------>

  static void listenNewMessages(Function(dynamic) onMessage) {
    if (socket == null) {
      debugPrint('❌ Socket is null');
      return;
    }

    socket!.off('message:new'); // IMPORTANT (avoid duplicate)

    socket!.on('message:new', (data) {
      debugPrint('📩 New chat received: $data');
      onMessage(data);
    });
  }

  ///<------------------ Listen for Events ------------------>
  static void onEvent(String eventName, Function(dynamic) callback) {
    if (socket != null && socket!.connected) {
      socket!.on(eventName, callback);
    } else {
      debugPrint('⚠️ Socket not connected. Cannot listen for "$eventName".');
    }
  }

  ///<------------------ Emit Events ------------------>
  static void sendEvent(String eventName, dynamic data) {
    if (!isConnected) {
      debugPrint('❌ Socket not connected. Cannot emit "$eventName".');
      return;
    }
    socket!.emit(eventName, data);
  }

  static void emitWithAck(
      String event,
      dynamic data, {
        required Function(dynamic response) ack,
        Duration timeout = const Duration(seconds: 5),
      }) {
    if (!isConnected) {
      debugPrint('❌ Socket not connected. Cannot emit "$event".');
      ack(false);
      return;
    }
    socket!.emitWithAck(event, data, ack: (response) => ack(response));
  }

  ///<------------------ Cleanup ------------------>
  static void dispose() {
    socket?.disconnect();
    socket?.dispose();
    socket = null;
    _isInitialized = false;
    _isConnecting = false;
    _userId = null;
    _onSocketConnectCallback = null;
    _connectCompleter = null;
    debugPrint('🧹 Socket disposed');
  }
}