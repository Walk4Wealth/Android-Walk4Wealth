import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/components/w_button.dart';
import '../../../core/utils/strings/asset_img_string.dart';
import '../../../domain/entity/product.dart';

class TransactionDetailPage extends StatelessWidget {
  const TransactionDetailPage({super.key, required this.product});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          //* foto produk // header
          _header(),
          const SizedBox(height: 16),

          //* reedem status
          // "Status hadiah: Digunakan"
          _reedemStatus(context),
          const SizedBox(height: 16),

          //* claim code container
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: LayoutBuilder(builder: (_, size) {
              return Row(
                children: [
                  //* foto produk
                  _productImage(size),
                  const SizedBox(width: 16),

                  //* kode klaim
                  _claimCode(context),
                  const SizedBox(width: 16),

                  //* icon copy
                  const Icon(
                    Icons.copy,
                    size: 20,
                    color: Colors.grey,
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),

          //* container information
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* nama produk
                _productName(context),

                //* tanggal kadaluarsa
                _expiration(context),

                //* dvider
                _divider(),

                //* poin yang digunakan
                _pointsUsed(context),
                const SizedBox(height: 16),

                //* transaction message
                // "Nikmatin poin kamu sebelum masa priode berakhir"
                _transactionMessage(),
                const SizedBox(height: 16),

                //* tutorial penggunaan poin
                _usageTutorial(context),
              ],
            ),
          ),
          const SizedBox(height: 16),

          //* back button
          _backButton(context),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      height: 250,
      color: Colors.black,
      child: CachedNetworkImage(
        imageUrl: product?.productImg ?? '',
        errorWidget: (_, __, ___) => Image.asset(AssetImg.error),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _reedemStatus(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Status Hadiah',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Digunakan',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _productImage(BoxConstraints size) {
    return SizedBox(
      width: size.maxWidth * 0.3,
      height: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: product?.productImg ?? '',
          errorWidget: (_, __, ___) => Image.asset(AssetImg.error),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _claimCode(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'kode Klaim',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          FittedBox(
            child: Text(
              'JSDB63FA52ONN',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productName(BuildContext context) {
    return Text(
      product?.name ?? '',
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _expiration(BuildContext context) {
    return Text(
      'Klaim sebelum ${DateFormat('dd MMMM yyyy', 'id').format(DateTime.parse(product?.expiration ?? '').toLocal())}',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _divider() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8),
        Divider(thickness: 1.1),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _pointsUsed(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Poin yang digunakan',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),

          // poin
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${product?.pointsRequired ?? 0} Poin',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor),
              ),
              Text('Stok ${product?.stock ?? 0}',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _transactionMessage() {
    return const Text('Nikmatin poin kamu sebelum masa priode berakhir');
  }

  Widget _usageTutorial(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: const ExpansionTile(
          title: Text('Cara Penggunaan'),
          children: [
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return WButton(
      expand: true,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      label: 'Kembali',
      onPressed: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
    );
  }
}
