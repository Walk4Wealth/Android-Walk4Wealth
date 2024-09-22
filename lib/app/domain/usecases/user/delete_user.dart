import '../../repositories/user_repository.dart';

class DeleteUser {
  final UserRepository _repository;

  DeleteUser({
    required UserRepository repository,
  }) : _repository = repository;

  Future<void> call() async => await _repository.deleteUser();
}
