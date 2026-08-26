// lib/core/network/api_exception.dart

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class NoInternetException extends ApiException {
  const NoInternetException()
      : super(message: 'No internet connection. Please check your network.');
}

// ⚠️ NOTE: dart:async তে আগে থেকেই একটা `TimeoutException` ক্লাস আছে।
// একই নামে নিজেদের ক্লাস বানালে যেই ফাইলে dart:async + এই ফাইল দুটোই
// import করা হবে (যেমন api_client.dart, api_service.dart), সেখানে
// "ambiguous import" error আসতো এবং পুরো build ভেঙে যেত।
// তাই এটার নাম পরিবর্তন করে ApiTimeoutException রাখা হলো।
class ApiTimeoutException extends ApiException {
  const ApiTimeoutException()
      : super(
    message: 'Request timed out. Please try again.',
    statusCode: 408,
  );
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    super.message = 'Session expired. Please log in again.',
    super.statusCode = 401,
  });
}

class ForbiddenException extends ApiException {
  const ForbiddenException()
      : super(
    message: 'You do not have permission to perform this action.',
    statusCode: 403,
  );
}

class NotFoundException extends ApiException {
  const NotFoundException({
    super.message = 'The requested resource was not found.',
    super.statusCode = 404,
  });
}

class BadRequestException extends ApiException {
  const BadRequestException({
    required super.message,
    super.statusCode = 400,
  });
}

class ValidationException extends ApiException {
  const ValidationException({
    required super.message,
    super.statusCode = 422,
  });
}

class TooManyRequestsException extends ApiException {
  const TooManyRequestsException()
      : super(
    message: 'Too many requests. Please slow down.',
    statusCode: 429,
  );
}

class ServerException extends ApiException {
  const ServerException({
    super.message = 'Server error. Please try again later.',
    super.statusCode = 500,
  });
}