import 'package:fpdart/fpdart.dart';

import '../../../core/error/failure.dart';
import '../../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository _repository;

  RegisterUser({
    required AuthRepository repository,
  }) : _repository = repository;

  Future<Either<Failure, void>> call({
    required String email,
    required String username,
    required String password,
    required int weight,
    required int height,
  }) async {
    return await _repository.register(
      email: email,
      username: username,
      password: password,
      weight: weight,
      height: height,
    );
  }
}
