import 'package:fpdart/fpdart.dart';

import '../../../core/error/failure.dart';
import '../../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository _repository;

  LoginUser({
    required AuthRepository repository,
  }) : _repository = repository;

  Future<Either<Failure, void>> call({
    required String email,
    required String password,
  }) async {
    return await _repository.login(email: email, password: password);
  }
}
