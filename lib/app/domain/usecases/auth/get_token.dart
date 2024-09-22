import '../../entity/token.dart';
import '../../repositories/auth_repository.dart';

class GetToken {
  final AuthRepository _repository;

  GetToken({
    required AuthRepository repository,
  }) : _repository = repository;

  Token call() => _repository.getToken();
}
