import 'package:dio/dio.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/error/error_type.dart';
import '../../../core/network/device_connection.dart';
import '../../../core/network/dio_client.dart';
import '../../../domain/usecases/auth/get_token.dart';
import '../../models/user_model.dart';

abstract interface class UserRemoteDatasource {
  Future<UserModel> getUser();
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final GetToken _getToken;
  final DioClient _dioClient;
  final DeviceConnection _connection;

  UserRemoteDatasourceImpl({
    required GetToken getToken,
    required DioClient dioClient,
    required DeviceConnection connection,
  })  : _getToken = getToken,
        _dioClient = dioClient,
        _connection = connection;

  @override
  Future<UserModel> getUser() async {
    if (await _connection.hasConnection()) {
      try {
        // token
        final token = _getToken.call().token;

        // request
        final response = await _dioClient.get(
          endpoint: '/auth/whoami',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        // parsing data
        final user = UserModel.fromRemote(response.data);

        // return user
        return user;
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
