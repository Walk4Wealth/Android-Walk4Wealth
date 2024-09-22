// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final int vendorId;
  final String? name;
  final String? description;
  final String? productImg;
  final int? pointsRequired;
  final String? expiration;
  final int? stock;
  final String status;
  final String createdAt;
  final String updatedAt;
  final List<Terms> terms;

  const Product({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.description,
    required this.productImg,
    required this.pointsRequired,
    required this.expiration,
    required this.stock,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.terms,
  });

  @override
  List<Object?> get props {
    return [
      id,
      vendorId,
      name,
      description,
      productImg,
      pointsRequired,
      expiration,
      stock,
      status,
      createdAt,
      updatedAt,
      terms,
    ];
  }
}

class Terms extends Equatable {
  final int number;
  final String description;

  const Terms({
    required this.number,
    required this.description,
  });

  @override
  List<Object?> get props => [number, description];
}
