import 'package:fpdart/fpdart.dart';

import '../../../core/error/failure.dart';
import '../../entity/history.dart';
import '../../repositories/point_repository.dart';

class GetHistoryTransaction {
  final PointRepository _repository;

  GetHistoryTransaction({
    required PointRepository repository,
  }) : _repository = repository;

  Future<Either<Failure, List<History>>> call() async {
    return await _repository.getTransactionHistory();
  }
}
