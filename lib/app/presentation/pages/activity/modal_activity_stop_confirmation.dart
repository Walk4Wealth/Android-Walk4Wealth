import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/components/w_button.dart';
import '../../../core/utils/strings/asset_img_string.dart';
import '../../providers/tracking_provider.dart';

class ModalActivityStopConfirmation extends StatelessWidget {
  const ModalActivityStopConfirmation({
    super.key,
    required this.resumeActivity,
    required this.stopActivity,
  });

  final void Function() resumeActivity;
  final void Function() stopActivity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Selesaikan Aktivitas',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Apakah kamu yakin ingin menyelesaikan aktivitas ini?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Image.asset(
                AssetImg.onBoarding3,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              'Berikut adalah pantauan sementara aktivitas kamu',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Consumer<TrackingProvider>(
                builder: (ctx, c, _) {
                  return Column(
                    children: [
                      //* durasi
                      _buildData(
                        context,
                        title: 'Durasi',
                        data: Text(
                          c.stringDuration,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(height: 4),

                      //* langkah
                      _buildData(
                        context,
                        title: 'Langkah',
                        data: Text.rich(TextSpan(
                          text: '${c.step}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.w500),
                          children: [
                            TextSpan(
                              text: ' langkah',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        )),
                      ),
                      const SizedBox(height: 4),

                      //* jarak tempuh
                      _buildData(
                        context,
                        title: 'Jarak tempuh',
                        isBold: true,
                        data: Text(
                          '${NumberFormat('#,###').format(c.mileage.toInt())} meter',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            //* action button
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: WButton(
                    label: 'Lanjutkan Aktivitas',
                    padding: 12,
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).primaryColor,
                    ),
                    type: ButtonType.OUTLINED,
                    onPressed: resumeActivity,
                  ),
                ),
                const SizedBox(width: 12),
                WButton(
                  label: 'Selesai',
                  padding: 12,
                  onPressed: stopActivity,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildData(
    BuildContext context, {
    required String title,
    required Widget data,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: (isBold)
              ? Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600)
              : Theme.of(context).textTheme.bodySmall,
        ),
        data,
      ],
    );
  }
}
