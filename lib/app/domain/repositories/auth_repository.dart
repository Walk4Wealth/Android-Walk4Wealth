import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';
import '../entity/token.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> register({
    required String email,
    required String username,
    required String password,
    required int weight,
    required int height,
  });

  Token getToken();
  Future<Either<Failure, void>> logout();
  bool isAuthenticated();
}
