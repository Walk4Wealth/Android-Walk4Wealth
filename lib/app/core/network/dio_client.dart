import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  final Dio _dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal()
      : _dio = Dio(
          BaseOptions(
            baseUrl:
                'http://w4w-dev.jasa-nikah-siri-amanah-profesional.com/api/v1',
            contentType: Headers.jsonContentType,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
          ),
        );

  Future<Response> get({
    required String endpoint,
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        data: data,
        options: options,
        cancelToken: cancelToken,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post({
    required String endpoint,
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: options,
        cancelToken: cancelToken,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
