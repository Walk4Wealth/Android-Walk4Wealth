import '../../domain/entity/vendor.dart';
import 'product_model.dart';

class VendorModel extends Vendor {
  const VendorModel({
    required super.id,
    required super.name,
    required super.logoUrl,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
    required super.vendorProducts,
  });

  factory VendorModel.fromRemote(Map<String, dynamic> map) {
    return VendorModel(
      id: map['id'],
      name: map['name'],
      logoUrl: map['logo_url'],
      description: map['description'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      vendorProducts: (map['vendor_product'] as List<dynamic>?)
              ?.map((data) => ProductModel.fromRemote(data))
              .toList() ??
          [],
    );
  }
}
