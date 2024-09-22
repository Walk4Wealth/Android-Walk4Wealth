import '../../repositories/auth_repository.dart';

class CheckAuthentication {
  final AuthRepository _repository;

  CheckAuthentication({
    required AuthRepository repository,
  }) : _repository = repository;

  bool call() => _repository.isAuthenticated();
}
