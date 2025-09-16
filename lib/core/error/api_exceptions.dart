import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ApiException(this.message, {this.statusCode, this.originalError});

  @override
  String toString() => 'ApiException: $message (Status code: $statusCode) Original Error: $originalError';
}

class ApiErrorHandler {
  static ApiException handle(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          'Connection timeout. Check your internet connection.',
          originalError: e,
        );
      case DioExceptionType.receiveTimeout:
        return ApiException(
          'Receive timeout. The server took too long to respond.',
          originalError: e,
        );
      case DioExceptionType.sendTimeout:
        return ApiException(
          'Send timeout. Request could not be sent.',
          originalError: e,
        );
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        final message = e.response?.data.toString() ?? 'Unknown server error';
        return ApiException(
          message,
          statusCode: status,
          originalError: e,
        );
      case DioExceptionType.cancel:
        return ApiException('Request was cancelled.', originalError: e);
      case DioExceptionType.unknown:
      default:
        return ApiException('Unexpected error: ${e.message}', originalError: e);
    }
  }
}
