import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/request_state.dart';
import '../../../core/utils/components/w_button.dart';
import '../../../core/utils/strings/asset_img_string.dart';
import '../../providers/shop_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/user_provider.dart';

class ModalConfirmRedemPoint extends StatelessWidget {
  const ModalConfirmRedemPoint({
    super.key,
    required this.cancleReedem,
    required this.reedem,
  });

  final void Function() cancleReedem;
  final void Function() reedem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Consumer<TransactionProvider>(
        builder: (_, c, child) {
          if (c.reedemPoinState == RequestState.LOADING) {
            return _loadingState();
          } else if (c.reedemPoinState == RequestState.FAILURE) {
            return _errorState(context);
          } else {
            return _modalView(context);
          }
        },
      ),
    );
  }

  Widget _loadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _modalView(BuildContext context) {
    final product = context.read<ShopProvider>().product;
    return Column(
      children: [
        //* title
        Text(
          'Konfirmasi penukaran poin',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        //* foto
        Expanded(
          child: Image.asset(
            AssetImg.reedemPoint,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 16),

        //* subtitle
        Text.rich(
          TextSpan(
            text: 'Kamu yakin ingin menukar Poin untuk ',
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                text: product?.name ?? '',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              TextSpan(
                  text: '?', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        //* detail poin
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

        //* action button
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WButton(
              label: 'Batal',
              padding: 12,
              type: ButtonType.OUTLINED,
              onPressed: cancleReedem,
            ),
            const SizedBox(width: 12),
            Flexible(
              fit: FlexFit.tight,
              child: WButton(
                label: 'Tukar',
                icon: const Icon(
                  Iconsax.gift,
                  size: 18,
                ),
                padding: 12,
                onPressed: reedem,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _errorState(BuildContext context) {
    return Column(
      children: [
        //* title
        Text(
          'Gagal menukarkan poin',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),

        //* foto
        Expanded(
          child: Image.asset(
            AssetImg.reedemPointError,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 16),

        //* subtitle
        Consumer<ShopProvider>(builder: (ctx, c, _) {
          return Text.rich(
            TextSpan(
              text: 'Maaf',
              style: Theme.of(context).textTheme.bodyLarge,
              children: [
                TextSpan(
                  text: ' ${c.product?.name} ',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: 'tidak bisa ditukar',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          );
        }),
        const SizedBox(height: 8),

        //* pesan
        Consumer<TransactionProvider>(builder: (ctx, c, _) {
          return Text(
            c.errorMessage ?? '',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          );
        }),
        const SizedBox(height: 16),

        //* action button
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WButton(
              label: 'Kembali',
              padding: 12,
              type: ButtonType.OUTLINED,
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 8),
            Flexible(
              fit: FlexFit.tight,
              child: WButton(
                expand: true,
                padding: 12,
                label: '',
                child: const Text(
                  'Lihat penawaran lainya',
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: () {
                  // tutup bottom nav bar
                  Navigator.of(context).pop();

                  // back halaman
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
