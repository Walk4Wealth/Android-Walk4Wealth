import 'dart:convert';

import '../../../core/db/local_db.dart';
import '../../../core/error/error_type.dart';
import '../../models/token_model.dart';

abstract interface class AuthLocalDatasource {
  Future<void> saveToken(TokenModel token);
  Future<void> deleteToken();
  TokenModel getToken();
  bool hasToken();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final Db _db;

  AuthLocalDatasourceImpl({required Db db}) : _db = db;

  @override
  bool hasToken() => _db.hasData(_db.TOKEN_KEY);

  @override
  Future<void> saveToken(TokenModel token) async {
    try {
      // parse token to string
      final stringToken = jsonEncode(token.toLocal());

      await _db.set(_db.TOKEN_KEY, stringToken);
    } catch (e) {
      throw ErrorType.DB_ERROR.getException(message: 'SAVE TOKEN [$e]');
    }
  }

  @override
  TokenModel getToken() {
    final stringToken = _db.get(_db.TOKEN_KEY);
    if (stringToken != null) {
      // parsing string to map
      final rawToken = jsonDecode(stringToken);

      // parsing map token to object
      final token = TokenModel.fromLocal(rawToken);

      // return token
      return token;
    } else {
      throw ErrorType.DB_NULL.getException(message: 'GET TOKEN').message;
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await _db.delete(_db.TOKEN_KEY);
    } catch (e) {
      throw ErrorType.DB_ERROR.getException(message: 'DELETE TOKEN $e');
    }
  }
}
