// ignore_for_file: constant_identifier_names

import 'app_exception.dart';

enum ErrorType {
  CANCEL,
  DEFAULT,
  DB_NULL,
  DB_ERROR,
  BAD_RESPONSE,
  SEND_TIMEOUT,
  RECEIVE_TIMEOUT,
  CONNECTION_TIMEOUT,
  NO_INTERNET_CONNECTION,
}

extension ErrorTypeExtension on ErrorType {
  AppException getException({int? code, String? message}) {
    switch (this) {
      case ErrorType.DEFAULT:
        return AppException(-1, 'Kesahalan sistem internal [$message]');
      case ErrorType.BAD_RESPONSE:
        return AppException(code ?? 0, message ?? 'Unknown Error');
      case ErrorType.CANCEL:
        return AppException(-2, 'Permintaan Dibatalkan, coba lagi nanti');
      case ErrorType.CONNECTION_TIMEOUT:
        return AppException(-3, 'Waktu koneksi habis, coba lagi nanti');
      case ErrorType.SEND_TIMEOUT:
        return AppException(-4,
            'Waktu tunggu untuk mengirim respons habis, silakan coba lagi nanti');
      case ErrorType.RECEIVE_TIMEOUT:
        return AppException(-5,
            'Waktu tunggu untuk menerima respons habis, silakan coba lagi nanti');
      case ErrorType.NO_INTERNET_CONNECTION:
        return AppException(-6, 'Periksa koneksi perangkat Anda');
      case ErrorType.DB_ERROR:
        return AppException(-7, 'Kesalahan pada Database $message');
      case ErrorType.DB_NULL:
        return AppException(-8, 'Data $message tidak tersedia didalam DB');
    }
  }
}
