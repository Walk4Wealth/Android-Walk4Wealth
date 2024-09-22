import 'package:fpdart/fpdart.dart';

import '../../entity/product.dart';
import '../../../core/error/failure.dart';
import '../../repositories/point_repository.dart';

class GetAllProduct {
  final PointRepository _repository;

  GetAllProduct({
    required PointRepository repository,
  }) : _repository = repository;

  Future<Either<Failure, List<Product>>> call() async {
    return await _repository.getAllProduct();
  }
}
