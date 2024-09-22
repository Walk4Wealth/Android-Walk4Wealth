import 'package:fpdart/fpdart.dart';

import '../../../core/error/failure.dart';
import '../../entity/vendor.dart';
import '../../repositories/point_repository.dart';

class GetVendorById {
  final PointRepository _repository;

  GetVendorById({
    required PointRepository repository,
  }) : _repository = repository;

  Future<Either<Failure, Vendor>> call({required int id}) async {
    return await _repository.getVendorById(id);
  }
}
