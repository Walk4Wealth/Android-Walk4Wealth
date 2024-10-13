import 'package:fpdart/fpdart.dart';

import '../../../core/error/failure.dart';
import '../../entity/activity.dart';
import '../../repositories/activity_repository.dart';

class GetActivity {
  final ActivityRepository _repository;

  GetActivity({
    required ActivityRepository repository,
  }) : _repository = repository;

  Future<Either<Failure, List<Activity>>> call() async {
    return await _repository.getActivity();
  }
}
