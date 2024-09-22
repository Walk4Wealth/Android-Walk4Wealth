import '../../domain/entity/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.vendorId,
    required super.name,
    required super.description,
    required super.productImg,
    required super.pointsRequired,
    required super.expiration,
    required super.stock,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    required super.terms,
  });

  factory ProductModel.fromRemote(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      vendorId: map['vendor_id'],
      name: map['name'],
      description: map['description'],
      productImg: map['product_img'],
      pointsRequired: map['points_required'],
      expiration: map['expiration'],
      stock: map['stock'],
      status: map['status'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      terms: (map['terms_and_conditions'] as List<dynamic>?)
              ?.map((data) => TermsModel.fromRemote(data))
              .toList() ??
          [],
    );
  }
}

class TermsModel extends Terms {
  const TermsModel({
    required super.number,
    required super.description,
  });

  factory TermsModel.fromRemote(Map<String, dynamic> map) {
    return TermsModel(
      number: map['number'],
      description: map['description'],
    );
  }
}
