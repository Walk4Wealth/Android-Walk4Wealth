import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/navigate.dart';
import '../../../core/utils/components/w_app_bar.dart';
import '../../../core/utils/components/w_button.dart';
import '../../providers/shop_provider.dart';

class TransactionSuccessPage extends StatelessWidget {
  const TransactionSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WAppBar(title: 'Status Penukaran'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //* success icon
            _successIcon(context),
            const SizedBox(height: 16),

            //* success title
            // "Berhasil"
            _successTitle(context),
            const SizedBox(height: 8),

            //* success subtitle
            // "Anda berhasil menukarkan poin untuk produk dengan informasi dibawah"
            _successSubtitle(context),
            const SizedBox(height: 8),

            //* container information
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* tanggal transaksi
                  _transactionDate(context),

                  //* divider
                  _productDivider(),

                  //* nama Produk
                  _productName(context),

                  //* divider
                  _productDivider(),

                  //* transaction info
                  Consumer<ShopProvider>(
                    builder: (ctx, c, _) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //* masa penawaran
                          _transactionSubInfo(
                            context,
                            title: 'Penawaran berakhir pada',
                            data: DateFormat('dd MMMM yyyy', 'id').format(
                              DateTime.parse(c.product?.expiration ?? ''),
                            ),
                          ),
                          const SizedBox(height: 8),

                          //* total poin
                          _transactionSubInfo(
                            context,
                            title: 'Total Poin',
                            data: '${c.product?.pointsRequired ?? 0}',
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            //* lihat detail transaksi
            _transactionDetailButton(context),
            const SizedBox(height: 12),

            //* kembali kehalaman utama
            _backButton(context),
          ],
        ),
      ),
    );
  }

  Widget _successIcon(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(
        Icons.check,
        size: 35,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  Text _successTitle(BuildContext context) {
    return Text(
      'Berhasil',
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w500),
    );
  }

  Text _successSubtitle(BuildContext context) {
    return Text(
      'Anda berhasil menukarkan poin untuk produk dengan informasi dibawah',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Text _transactionDate(BuildContext context) {
    return Text(
      DateFormat('HH:mm a, dd/MM/yyyy', 'id').format(
        DateTime.now(),
      ),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _productName(BuildContext context) {
    return Consumer<ShopProvider>(
      builder: (_, c, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              c.product?.name ?? '',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }

  Widget _productDivider() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 4),
        Divider(thickness: 1.1),
        SizedBox(height: 4),
      ],
    );
  }

  Widget _transactionSubInfo(
    BuildContext context, {
    required String title,
    required String data,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          data,
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
        ),
      ],
    );
  }

  Widget _backButton(BuildContext context) {
    return WButton(
      expand: true,
      type: ButtonType.OUTLINED,
      label: 'Kembali Kehalaman Utama',
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _transactionDetailButton(BuildContext context) {
    return WButton(
      expand: true,
      label: 'Lihat Detail',
      onPressed: () {
        final product = context.read<ShopProvider>().product;
        Navigator.pushNamedAndRemoveUntil(
          context,
          To.TRANSACTION_DETAIL,
          arguments: product,
          (route) => route.isFirst,
        );
      },
    );
  }
}
