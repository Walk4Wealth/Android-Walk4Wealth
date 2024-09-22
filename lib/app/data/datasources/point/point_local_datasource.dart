import '../../../core/cache/cache_manager.dart';

import '../../models/product_model.dart';
import '../../models/vendor_model.dart';

abstract interface class PointLocalDatasource {
  bool hasVendor();
  bool hasProduct();
  List<VendorModel>? getAllVendor();
  List<ProductModel>? getAllProduct();
  void saveAllVendor(List<VendorModel> vendors);
  void saveAllProduct(List<ProductModel> products);
}

class PointLocalDatasourceImpl implements PointLocalDatasource {
  final CacheManager _cache;

  PointLocalDatasourceImpl({
    required CacheManager cache,
  }) : _cache = cache;

  @override
  bool hasVendor() => getAllVendor() != null;

  @override
  bool hasProduct() => getAllProduct() != null;

  @override
  List<VendorModel>? getAllVendor() => _cache.vendors;

  @override
  List<ProductModel>? getAllProduct() => _cache.products;

  @override
  void saveAllVendor(List<VendorModel> vendors) {
    _cache.setVendor(vendors);
  }

  @override
  void saveAllProduct(List<ProductModel> products) {
    _cache.setProduct(products);
  }
}
