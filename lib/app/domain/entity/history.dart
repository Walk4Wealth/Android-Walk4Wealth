import 'package:equatable/equatable.dart';

import 'product.dart';

class History extends Equatable {
  final int id;
  final int userId;
  final int vendorProductId;
  final int pointUsed;
  final String timeStamp;
  final String createdAt;
  final String updatedAt;
  final Product product;

  const History({
    required this.id,
    required this.userId,
    required this.vendorProductId,
    required this.pointUsed,
    required this.timeStamp,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  @override
  List<Object> get props {
    return [
      id,
      userId,
      vendorProductId,
      pointUsed,
      timeStamp,
      createdAt,
      updatedAt,
      product,
    ];
  }
}
