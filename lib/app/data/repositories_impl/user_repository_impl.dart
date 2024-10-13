import 'dart:developer';

import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';
import '../../domain/entity/user.dart';
import '../../core/error/app_exception.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user/user_local_datasource.dart';
import '../datasources/user/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDatasource _localDatasource;
  final UserRemoteDatasource _remoteDatasource;

  UserRepositoryImpl({
    required UserLocalDatasource localDatasource,
    required UserRemoteDatasource remoteDatasource,
  })  : _localDatasource = localDatasource,
        _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, User>> getUser() async {
    final hasUserInLocalDb = _localDatasource.hasUser();

    // get data user dari local db jika tersedia
    if (hasUserInLocalDb) {
      final localUser = _localDatasource.getUser();
      return right(localUser);
    } else {
      // get user dari server
      try {
        final remoteUser = await _remoteDatasource.getUser();
        log('user ${remoteUser.username} berhasil di get');

        // save user in db
        await _localDatasource.saveUser(remoteUser);

        return right(remoteUser);
      } on AppException catch (e) {
        return left(Failure(code: e.code, message: e.message));
      }
    }
  }

  @override
  Future<void> deleteUser() async {
    await _localDatasource.deleteUser();
  }

  @override
  Future<Either<Failure, User>> updateUser() async {
    try {
      // get user dari server kemudian save ke db
      final remoteUser = await _remoteDatasource.getUser();
      await _localDatasource.saveUser(remoteUser);

      // logger
      log('User berhasil diget dari remote saat update user');

      // return local user
      final localUser = _localDatasource.getUser();
      return right(localUser);
    } on AppException catch (e) {
      return left(Failure(code: e.code, message: e.message));
    }
  }
}
