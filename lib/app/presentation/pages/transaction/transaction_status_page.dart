import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/navigate.dart';
import '../../../core/utils/components/w_app_bar.dart';
import '../../../core/utils/components/w_button.dart';
import '../../providers/shop_provider.dart';

class TransactionStatusPage extends StatelessWidget {
  const TransactionStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WAppBar(title: 'Status Penukaran'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // status
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(
                Icons.check,
                size: 35,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Berhasil',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),

            Text(
              'Anda berhasil menukarkan poin untuk produk dengan informasi dibawah',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),

            // informasi
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
                  // tanggal transaksi
                  Text(
                    DateFormat('HH:mm a, dd/MM/yyyy', 'id').format(
                      DateTime.now(),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  const Divider(thickness: 1.1),
                  const SizedBox(height: 4),

                  // Nama Produk
                  Consumer<ShopProvider>(
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
                  ),
                  const SizedBox(height: 4),
                  const Divider(thickness: 1.1),
                  const SizedBox(height: 4),

                  // tanggal kadaluarsa
                  Consumer<ShopProvider>(
                    builder: (_, c, child) {
                      final masa = DateFormat('dd MMMM yyyy', 'id').format(
                        DateTime.parse(c.product?.expiration ?? ''),
                      );
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // masa penawaran
                          _transactionInfo(
                            context,
                            title: 'Penawaran berakhir pada',
                            data: masa,
                          ),
                          const SizedBox(height: 8),
                          // total poin
                          _transactionInfo(
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

            // button kembali
            WButton(
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
            ),
            const SizedBox(height: 12),
            WButton(
              expand: true,
              type: ButtonType.OUTLINED,
              label: 'Kembali Kehalaman Utama',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionInfo(
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
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ],
    );
  }
}
