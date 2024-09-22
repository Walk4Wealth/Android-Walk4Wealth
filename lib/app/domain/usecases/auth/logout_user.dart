import 'package:fpdart/fpdart.dart';

import '../../../core/error/failure.dart';
import '../../repositories/auth_repository.dart';

class LogoutUser {
  final AuthRepository _repository;

  LogoutUser({
    required AuthRepository repository,
  }) : _repository = repository;

  Future<Either<Failure, void>> call() async {
    return await _repository.logout();
  }
}
