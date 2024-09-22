import '../../domain/entity/history.dart';
import 'product_model.dart';

class HistoryModel extends History {
  const HistoryModel({
    required super.id,
    required super.userId,
    required super.vendorProductId,
    required super.pointUsed,
    required super.timeStamp,
    required super.createdAt,
    required super.updatedAt,
    required super.product,
  });

  factory HistoryModel.fromRemote(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['id'],
      userId: map['user_id'],
      vendorProductId: map['vendor_product_id'],
      pointUsed: map['points_used'],
      timeStamp: map['timestamp'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      product: ProductModel.fromRemote(map['vendor_product']),
    );
  }
}
