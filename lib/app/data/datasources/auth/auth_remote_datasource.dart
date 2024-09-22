import 'package:dio/dio.dart';

import '../../../core/error/error_type.dart';
import '../../../core/network/device_connection.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/error/app_exception.dart';
import '../../models/token_model.dart';

abstract interface class AuthRemoteDatasource {
  Future<TokenModel> login({
    required String email,
    required String password,
  });

  Future<TokenModel> register({
    required String email,
    required String username,
    required String password,
    required int weight,
    required int height,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient _dioClient;
  final DeviceConnection _connection;

  AuthRemoteDatasourceImpl({
    required DioClient dioClient,
    required DeviceConnection connection,
  })  : _dioClient = dioClient,
        _connection = connection;

  @override
  Future<TokenModel> login({
    required String email,
    required String password,
  }) async {
    if (await _connection.hasConnection()) {
      try {
        // post
        final response = await _dioClient.post(
          endpoint: '/auth/signin',
          data: {"email": email, "password": password},
        );

        // parsing data
        final token = TokenModel.fromRemote(response.data);

        // return token
        return token;
      } on DioException catch (e) {
        throw AppException.handle(e);
      } catch (e) {
        throw AppException.handle(e);
      }
    } else {
      throw ErrorType.NO_INTERNET_CONNECTION.getException();
    }
  }

  @override
  Future<TokenModel> register({
    required String email,
    required String username,
    required String password,
    required int weight,
    required int height,
  }) async {
    if (await _connection.hasConnection()) {
      try {
        // post
        final response = await _dioClient.post(
          endpoint: '/auth/signup',
          data: {
            "username": username,
            "email": email,
            "password": password,
            "weight": weight,
            "height": height
          },
        );

        // parsing data
        final token = TokenModel.fromRemote(response.data);

        // return token
        return token;
      } on DioException catch (e) {
        throw AppException.handle(e);
      } catch (e) {
        throw AppException.handle(e);
      }
    } else {
      throw ErrorType.NO_INTERNET_CONNECTION.getException();
    }
  }
}
