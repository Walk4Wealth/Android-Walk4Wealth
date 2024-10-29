import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/routes/navigate.dart';
import '../../core/utils/strings/asset_img_string.dart';
import '../../domain/entity/history.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard(this.history, {super.key});

  final History history;

  void _navigateToTransactionDetailPage(BuildContext context) {
    Navigator.pushNamed(
      context,
      To.TRANSACTION_DETAIL,
      arguments: history.product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _productImage(),
      title: _productName(),
      subtitle: _transactionDate(),
      trailing: _pointsUsed(),
      onTap: () => _navigateToTransactionDetailPage(context),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      titleTextStyle: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w500),
    );
  }

  Widget _productImage() {
    return CachedNetworkImage(
      imageUrl: history.product.productImg ?? '',
      errorWidget: (_, __, ___) => Image.asset(AssetImg.error),
      width: 50,
      fit: BoxFit.cover,
    );
  }

  Widget _productName() {
    return Text(
      history.product.name ?? '',
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _transactionDate() {
    return Text(
      DateFormat('dd/MM/yyyy HH:mm:ss a', 'id').format(
        DateTime.parse(history.timeStamp).toLocal(),
      ),
    );
  }

  Widget _pointsUsed() {
    return Text('${history.product.pointsRequired ?? 0} Poin');
  }
}
