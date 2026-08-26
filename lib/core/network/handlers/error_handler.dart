// lib/core/network/error_handler.dart

import 'dart:async';
import 'dart:io';

import '../../service/google/google_auth.dart';
import '../interceptors/network_logger.dart';
import '../models/api_response.dart';

class ErrorHandler {
  ErrorHandler._();

  // ✅ যেকোনো exception → proper message সহ ApiResponse এ convert করে
  static ApiResponse handle(dynamic error, String url, String method) {
    NetworkLogger.logError(method: method, url: url, error: error);

    // No Internet
    if (error is SocketException) {
      return const ApiResponse(
        statusCode: 0,
        status: ApiStatus.noInternet,
        errorMessage: 'No internet connection. Please check your network.',
      );
    }

    // Timeout (dart:async এর TimeoutException — .timeout() থেকে আসে)
    if (error is TimeoutException) {
      return const ApiResponse(
        statusCode: 408,
        status: ApiStatus.timeout,
        errorMessage: 'Request timed out. Please try again.',
      );
    }

    // Secure connection / SSL fail
    if (error is HandshakeException) {
      return const ApiResponse(
        statusCode: 0,
        status: ApiStatus.serverError,
        errorMessage: 'Secure connection failed. Please try again.',
      );
    }

    // HTTP exception
    if (error is HttpException) {
      return ApiResponse(
        statusCode: 500,
        status: ApiStatus.serverError,
        errorMessage: error.message.isNotEmpty
            ? error.message
            : 'Something went wrong with the server connection.',
      );
    }

    // Response JSON parse করতে ব্যর্থ হলে
    if (error is FormatException) {
      NetworkLogger.logWarning('Response format error: ${error.message}');
      return const ApiResponse(
        statusCode: 500,
        status: ApiStatus.serverError,
        errorMessage: 'Invalid response format from server.',
      );
    }

    // আমাদের নিজেদের ApiException (এবং এর সব subclass: Unauthorized, NotFound ইত্যাদি)
    if (error is ApiException) {
      return ApiResponse(
        statusCode: error.statusCode,
        status: error.statusCode == 401 ? ApiStatus.unauthorized : ApiStatus.error,
        errorMessage: error.message,
      );
    }

    // http package এর ClientException (connection reset / socket বন্ধ হয়ে যাওয়া)
    final errorMsg = error.toString();
    if (errorMsg.contains('ClientException')) {
      return const ApiResponse(
        statusCode: 0,
        status: ApiStatus.noInternet,
        errorMessage: 'Connection lost. Please check your internet and try again.',
      );
    }

    // Unknown
    return ApiResponse(
      statusCode: 1,
      status: ApiStatus.error,
      errorMessage: errorMsg.isNotEmpty ? errorMsg : 'An unexpected error occurred.',
    );
  }

  // ✅ statusCode → proper ApiResponse (server response আসার পর)
  static ApiResponse fromStatusCode(int statusCode, dynamic body, String? reasonPhrase) {
    switch (statusCode) {
      case 200:
      case 201:
      case 204:
        return ApiResponse(
          statusCode: statusCode,
          body: body,
          status: ApiStatus.success,
          statusText: reasonPhrase,
        );

      case 400:
        final msg = _extractMessage(body) ?? 'Bad request.';
        NetworkLogger.logWarning('400 Bad Request: $msg');
        return ApiResponse(
          statusCode: 400,
          body: body,
          status: ApiStatus.error,
          errorMessage: msg,
        );

      case 401:
        final msg = _extractMessage(body) ?? 'Session expired. Please log in again.';
        NetworkLogger.logWarning('401 Unauthorized: $msg');
        return ApiResponse(
          statusCode: 401,
          body: body,
          status: ApiStatus.unauthorized,
          errorMessage: msg,
        );

      case 403:
        NetworkLogger.logWarning('403 Forbidden.');
        return ApiResponse(
          statusCode: 403,
          body: body,
          status: ApiStatus.error,
          errorMessage:
          _extractMessage(body) ?? 'You do not have permission to perform this action.',
        );

      case 404:
        NetworkLogger.logWarning('404 Not Found.');
        return ApiResponse(
          statusCode: 404,
          body: body,
          status: ApiStatus.error,
          errorMessage: _extractMessage(body) ?? 'The requested resource was not found.',
        );

      case 408:
        return const ApiResponse(
          statusCode: 408,
          status: ApiStatus.timeout,
          errorMessage: 'Request timed out.',
        );

      case 422:
        final msg = _extractMessage(body) ?? 'Validation failed.';
        NetworkLogger.logWarning('422 Unprocessable: $msg');
        return ApiResponse(
          statusCode: 422,
          body: body,
          status: ApiStatus.error,
          errorMessage: msg,
        );

      case 429:
        return ApiResponse(
          statusCode: 429,
          body: body,
          status: ApiStatus.error,
          errorMessage: _extractMessage(body) ?? 'Too many requests. Please slow down.',
        );

      case 500:
      case 502:
      case 503:
      case 504:
        NetworkLogger.logError(method: 'SERVER', url: '', error: 'Server error $statusCode');
        return ApiResponse(
          statusCode: statusCode,
          body: body,
          status: ApiStatus.serverError,
          errorMessage: _extractMessage(body) ?? 'Server error. Please try again later.',
        );

      default:
        return ApiResponse(
          statusCode: statusCode,
          body: body,
          status: ApiStatus.error,
          errorMessage: _extractMessage(body) ?? 'Unexpected error (code: $statusCode).',
        );
    }
  }

  // ✅ response body থেকে message safely বের করে
  static String? _extractMessage(dynamic body) {
    if (body is Map) {
      final msg = body['message'] ?? body['error'] ?? body['msg'] ?? body['chat'];
      if (msg is String && msg.trim().isNotEmpty) return msg;
      if (msg is List && msg.isNotEmpty) return msg.first.toString();
    }
    return null;
  }
}