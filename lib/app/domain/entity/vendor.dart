// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'product.dart';

class Vendor extends Equatable {
  final int id;
  final String name;
  final String? logoUrl;
  final String? description;
  final String createdAt;
  final String updatedAt;
  final List<Product> vendorProducts;

  const Vendor({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.vendorProducts,
  });

  @override
  List<Object?> get props {
    return [
      id,
      name,
      logoUrl,
      description,
      createdAt,
      updatedAt,
      vendorProducts,
    ];
  }
}
