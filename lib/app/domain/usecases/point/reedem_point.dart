import 'package:fpdart/fpdart.dart';

import '../../../core/error/failure.dart';
import '../../repositories/point_repository.dart';

class ReedemPoint {
  final PointRepository _repository;

  ReedemPoint({
    required PointRepository repository,
  }) : _repository = repository;

  Future<Either<Failure, void>> call({
    required int userId,
    required int productId,
  }) async {
    return await _repository.reedemPoint(
      userId: userId,
      productId: productId,
    );
  }
}
