import 'package:dio/dio.dart';

import 'error_type.dart';

class AppException implements Exception {
  final int code;
  final String message;

  AppException(this.code, this.message);

  factory AppException.handle(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    } else {
      final message = (error as Object);
      return ErrorType.DEFAULT.getException(message: message.toString());
    }
  }

  static AppException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ErrorType.CONNECTION_TIMEOUT.getException();
      case DioExceptionType.sendTimeout:
        return ErrorType.SEND_TIMEOUT.getException();
      case DioExceptionType.receiveTimeout:
        return ErrorType.RECEIVE_TIMEOUT.getException();
      case DioExceptionType.cancel:
        return ErrorType.CANCEL.getException();
      case DioExceptionType.badResponse:
        return ErrorType.BAD_RESPONSE.getException(
          code: error.response?.statusCode,
          message: error.response?.data['message'],
        );
      default:
        return AppException(
          error.response?.statusCode ?? 400,
          'Kesalahan server yang tidak diketahui : ${error.message}',
        );
    }
  }
}
