// lib/core/network/network_logger.dart

import 'package:logger/logger.dart';

class NetworkLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  // ✅ Request log
  static void logRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
  }) {
    _logger.i(
      '📤 $method REQUEST'
          '\n┌─────────────────────────────'
          '\n│ URL     : $url'
          '\n│ Headers : $headers'
          '\n│ Body    : $body'
          '\n└─────────────────────────────',
    );
  }

  // ✅ Response log
  static void logResponse({
    required String url,
    required int statusCode,
    dynamic body,
  }) {
    final isSuccess = statusCode >= 200 && statusCode < 300;
    final log = '📥 RESPONSE'
        '\n┌─────────────────────────────'
        '\n│ URL    : $url'
        '\n│ Status : $statusCode'
        '\n│ Body   : $body'
        '\n└─────────────────────────────';

    if (isSuccess) {
      _logger.i(log);
    } else {
      _logger.w(log);
    }
  }

  // ✅ Error log
  static void logError({
    required String method,
    required String url,
    required dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.e(
      '❌ $method ERROR'
          '\n┌─────────────────────────────'
          '\n│ URL   : $url'
          '\n│ Error : $error'
          '\n└─────────────────────────────',
      error: error,
      stackTrace: stackTrace,
    );
  }

  // ✅ Info log (general)
  static void logInfo(String message) => _logger.i('ℹ️ $message');

  // ✅ Warning log
  static void logWarning(String message) => _logger.w('⚠️ $message');

  // ✅ Debug log
  static void logDebug(String message) => _logger.d('🐛 $message');
}