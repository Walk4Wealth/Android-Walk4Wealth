import '../../data/models/product_model.dart';
import '../../data/models/vendor_model.dart';

class CacheManager {
  static CacheManager? _instance;

  CacheManager._internal() {
    _instance = this;
  }

  factory CacheManager() => _instance ?? CacheManager._internal();

  List<VendorModel>? _vendors;
  List<VendorModel>? get vendors => _vendors;

  List<ProductModel>? _products;
  List<ProductModel>? get products => _products;

  void setVendor(List<VendorModel> vendors) {
    _vendors = vendors;
  }

  void setProduct(List<ProductModel> products) {
    _products = products;
  }

  void clear() {
    _vendors = null;
    _products = null;
  }
}
