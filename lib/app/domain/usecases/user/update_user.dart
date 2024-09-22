import 'package:fpdart/fpdart.dart';

import '../../../core/error/failure.dart';
import '../../entity/user.dart';
import '../../repositories/user_repository.dart';

class UpdateUser {
  final UserRepository _repository;

  UpdateUser({
    required UserRepository repository,
  }) : _repository = repository;

  Future<Either<Failure, User>> call() async {
    return await _repository.updateUser();
  }
}
