import 'package:fpdart/fpdart.dart';

import '../../entity/product.dart';
import '../../../core/error/failure.dart';
import '../../repositories/point_repository.dart';

class GetProductById {
  final PointRepository _repository;

  GetProductById({
    required PointRepository repository,
  }) : _repository = repository;

  Future<Either<Failure, Product>> call({required int id}) async {
    return await _repository.getProductById(id);
  }
}
