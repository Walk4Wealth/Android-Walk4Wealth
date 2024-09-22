import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';
import '../entity/history.dart';
import '../entity/product.dart';
import '../entity/vendor.dart';

abstract interface class PointRepository {
  Future<Either<Failure, List<Vendor>>> getAllVendor();
  Future<Either<Failure, Vendor>> getVendorById(int id);
  Future<Either<Failure, List<Product>>> getAllProduct();
  Future<Either<Failure, Product>> getProductById(int id);
  Future<Either<Failure, List<History>>> getTransactionHistory();
  Future<Either<Failure, void>> reedemPoint({
    required int userId,
    required int productId,
  });
}
