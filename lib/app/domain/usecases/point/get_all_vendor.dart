import 'package:fpdart/fpdart.dart';

import '../../entity/vendor.dart';
import '../../../core/error/failure.dart';
import '../../repositories/point_repository.dart';

class GetAllVendor {
  final PointRepository _repository;

  GetAllVendor({
    required PointRepository repository,
  }) : _repository = repository;

  Future<Either<Failure, List<Vendor>>> call() async {
    return await _repository.getAllVendor();
  }
}
