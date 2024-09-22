import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/enum/request_state.dart';
import '../../core/utils/components/w_button.dart';
import '../../core/utils/strings/asset_img_string.dart';
import '../providers/shop_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/user_provider.dart';

class ConfirmReedemBottomSheet extends StatelessWidget {
  const ConfirmReedemBottomSheet({
    super.key,
    required this.action,
  });

  final List<Widget> action;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints().copyWith(
        maxHeight: MediaQuery.of(context).size.height * 0.45,
      ),
      padding: EdgeInsets.only(
        top: 8,
        left: 8,
        right: 8,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Consumer<TransactionProvider>(
        builder: (_, c, child) {
          if (c.reedemPoinState == RequestState.LOADING) {
            return _loadingState();
          } else if (c.reedemPoinState == RequestState.FAILURE) {
            return _errorState(context);
          } else {
            return _initState(context);
          }
        },
      ),
    );
  }

  Widget _loadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _initState(BuildContext context) {
    final product = context.read<ShopProvider>().product;
    return Column(
      children: [
        Expanded(
          child: Image.asset(
            AssetImg.reedemPoint,
            fit: BoxFit.contain,
          ),
        ),

        // title
        Text(
          'Konfirmasi penukaran poin',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),

        // poin kamu
        Text.rich(TextSpan(
          text: 'Anda ingin menukar Poin untuk ',
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: product?.name ?? '',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: '?', style: Theme.of(context).textTheme.bodyMedium),
          ],
        )),
        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Poin Kamu',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Consumer<UserProvider>(builder: (_, c, child) {
                    return Text(
                      '${c.user?.totalPoints ?? 0} Poin',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Poin yang dibutuhkan',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${product?.pointsRequired ?? 0} Poin',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // action button
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: action,
        ),
      ],
    );
  }

  Widget _errorState(BuildContext context) {
    final product = context.read<ShopProvider>().product;
    return Column(
      children: [
        Expanded(
          child: Image.asset(
            AssetImg.reedemPointError,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 16),

        // title
        Text.rich(
          TextSpan(
            text: 'Maaf',
            style: Theme.of(context).textTheme.titleLarge,
            children: [
              TextSpan(
                text: ' ${product?.name} ',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'tidak bisa ditukar',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),

        // peesan
        Text(
          'Kamu hanya bisa menukarkan satu kali saja untuk produk yang sama',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),

        // action button
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WButton(
              label: 'Kembali',
              padding: 12,
              type: ButtonType.OUTLINED,
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 8),
            Flexible(
              fit: FlexFit.tight,
              child: WButton(
                expand: true,
                padding: 12,
                label: '',
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Lihat penawaran lainya'),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
                onPressed: () {
                  // tutup bottom nav bar
                  Navigator.pop(context);

                  // back halaman
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
