import 'package:fpdart/fpdart.dart';

import '../../../core/error/failure.dart';
import '../../entity/user.dart';
import '../../repositories/user_repository.dart';

class GetUser {
  final UserRepository _repository;

  GetUser({
    required UserRepository repository,
  }) : _repository = repository;

  Future<Either<Failure, User>> call() async {
    return await _repository.getUser();
  }
}
