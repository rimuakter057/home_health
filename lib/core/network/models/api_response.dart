// lib/core/network/api_response.dart

enum ApiStatus { success, error, noInternet, unauthorized, timeout, serverError }

class ApiResponse {
  final int? statusCode;
  final dynamic body;
  final String? statusText;
  final Map<String, String>? headers;
  final ApiStatus status;
  final String? errorMessage;

  const ApiResponse({
    this.statusCode,
    this.body,
    this.statusText,
    this.headers,
    this.status = ApiStatus.success,
    this.errorMessage,
  });

  // ✅ Status Checkers
  bool get isSuccess =>
      status == ApiStatus.success &&
          statusCode != null &&
          statusCode! >= 200 &&
          statusCode! < 300;
  bool get isUnauthorized => statusCode == 401 || status == ApiStatus.unauthorized;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError =>
      status == ApiStatus.serverError ||
          (statusCode != null && statusCode! >= 500 && statusCode! < 600);
  bool get isNoInternet => status == ApiStatus.noInternet;
  bool get isTimeout => status == ApiStatus.timeout;
  bool get hasError => !isSuccess;

  // ✅ Get message from body safely
  String get message {
    if (errorMessage != null && errorMessage!.trim().isNotEmpty) return errorMessage!;
    if (body is Map) {
      return body['message'] ??
          body['error'] ??
          body['msg'] ??
          statusText ??
          'Something went wrong';
    }
    return statusText ?? 'Something went wrong';
  }

  // ✅ Get data from body safely
  dynamic get data {
    if (body is Map) return body['data'] ?? body;
    return body;
  }

  @override
  String toString() =>
      'ApiResponse(status: $status, statusCode: $statusCode, message: $message)';
}