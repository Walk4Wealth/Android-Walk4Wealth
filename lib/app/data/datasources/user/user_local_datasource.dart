import 'dart:convert';

import '../../../core/db/local_db.dart';
import '../../../core/error/error_type.dart';
import '../../models/user_model.dart';

abstract interface class UserLocalDatasource {
  Future<void> saveUser(UserModel user);
  Future<void> deleteUser();
  UserModel getUser();
  bool hasUser();
}

class UserLocalDatasourceImpl implements UserLocalDatasource {
  final Db _db;

  UserLocalDatasourceImpl({required Db db}) : _db = db;

  @override
  UserModel getUser() {
    final stringUser = _db.get(_db.USER_KEY);
    if (stringUser != null) {
      // parsing strng to map
      final rawUser = jsonDecode(stringUser);

      // parsing map user to object
      final user = UserModel.fromLocal(rawUser);

      // return user
      return user;
    } else {
      throw ErrorType.DB_NULL.getException(message: 'GET USER').message;
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      await _db.delete(_db.USER_KEY);
    } catch (e) {
      throw ErrorType.DB_ERROR.getException(message: e.toString());
    }
  }

  @override
  bool hasUser() {
    return _db.hasData(_db.USER_KEY);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      // parse user to string
      final stringUser = jsonEncode(user.toLocal());

      await _db.set(_db.USER_KEY, stringUser);
    } catch (e) {
      throw ErrorType.DB_ERROR.getException(message: 'SAVE USER [$e]');
    }
  }
}
