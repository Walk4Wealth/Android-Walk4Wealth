import 'package:fpdart/fpdart.dart';

import '../../core/error/app_exception.dart';
import '../../core/error/failure.dart';
import '../../domain/entity/history.dart';
import '../../domain/entity/product.dart';
import '../../domain/entity/vendor.dart';
import '../../domain/repositories/point_repository.dart';
import '../datasources/point/point_local_datasource.dart';
import '../datasources/point/point_remote_datasource.dart';

class PointRepositoryImpl implements PointRepository {
  final PointLocalDatasource _localDatasource;
  final PointRemoteDatasource _remoteDatasource;

  PointRepositoryImpl({
    required PointLocalDatasource localDatasource,
    required PointRemoteDatasource remoteDatasource,
  })  : _localDatasource = localDatasource,
        _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, List<Vendor>>> getAllVendor() async {
    if (_localDatasource.hasVendor()) {
      // return local vendors
      final localVendors = _localDatasource.getAllVendor();
      return right(localVendors!);
    } else {
      // remote vendors
      try {
        final remoteVendors = await _remoteDatasource.getAllVendor();

        // save vendors to cache
        _localDatasource.saveAllVendor(remoteVendors);

        return right(remoteVendors);
      } on AppException catch (e) {
        return left(Failure(code: e.code, message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Vendor>> getVendorById(int id) async {
    try {
      final vendorById = await _remoteDatasource.getVendorById(id);
      return right(vendorById);
    } on AppException catch (e) {
      return left(Failure(code: e.code, message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getAllProduct() async {
    if (_localDatasource.hasProduct()) {
      // return local products
      final localProducts = _localDatasource.getAllProduct();
      return right(localProducts!);
    } else {
      // remote products
      try {
        final remoteProducts = await _remoteDatasource.getAllProduct();

        // save product to cache
        _localDatasource.saveAllProduct(remoteProducts);

        return right(remoteProducts);
      } on AppException catch (e) {
        return left(Failure(code: e.code, message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    try {
      final productById = await _remoteDatasource.getProductById(id);
      return right(productById);
    } on AppException catch (e) {
      return left(Failure(code: e.code, message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<History>>> getTransactionHistory() async {
    // remote history
    try {
      final remoteHistory = await _remoteDatasource.getTransactionHistory();

      return right(remoteHistory);
    } on AppException catch (e) {
      return left(Failure(code: e.code, message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> reedemPoint({
    required int userId,
    required int productId,
  }) async {
    try {
      // reedem poin
      await _remoteDatasource.reedemPoint(
        userId: userId,
        productId: productId,
      );

      return right(null);
    } on AppException catch (e) {
      return left(Failure(code: e.code, message: e.message));
    }
  }
}
