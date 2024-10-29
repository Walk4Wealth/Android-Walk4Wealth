import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';
import '../../core/error/app_exception.dart';
import '../../domain/entity/token.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth/auth_local_datasource.dart';
import '../datasources/auth/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource _localDatasource;
  final AuthRemoteDatasource _remoteDatasource;

  AuthRepositoryImpl({
    required AuthLocalDatasource localDatasource,
    required AuthRemoteDatasource remoteDatasource,
  })  : _localDatasource = localDatasource,
        _remoteDatasource = remoteDatasource;

  @override
  bool isAuthenticated() => _localDatasource.hasToken();

  @override
  Token getToken() => _localDatasource.getToken();

  @override
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) async {
    try {
      // login
      final token = await _remoteDatasource.login(
        email: email,
        password: password,
      );

      // save token to db
      await _localDatasource.saveToken(token);

      return right(null);
    } on AppException catch (e) {
      return left(Failure(code: e.code, message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> register({
    required String email,
    required String username,
    required String password,
    required int weight,
    required int height,
  }) async {
    try {
      // register
      final token = await _remoteDatasource.register(
        email: email,
        username: username,
        password: password,
        weight: weight,
        height: height,
      );

      // save token
      await _localDatasource.saveToken(token);

      return right(null);
    } on AppException catch (e) {
      return left(Failure(code: e.code, message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // hapus token dan user dari local db
      await _localDatasource.deleteToken();

      return right(null);
    } on AppException catch (e) {
      return left(Failure(code: e.code, message: e.message));
    }
  }
}
