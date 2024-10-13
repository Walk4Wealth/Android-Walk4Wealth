import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/activity_mode.dart';
import '../../../core/utils/components/w_button.dart';
import '../../../core/utils/strings/asset_img_string.dart';
import '../../providers/tracking_provider.dart';

class ModalActivityModeSelection extends StatelessWidget {
  const ModalActivityModeSelection({
    super.key,
    required this.startActivity,
    required this.cancelActivity,
  });

  final void Function() startActivity;
  final void Function() cancelActivity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Pilih mode aktivitas',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<TrackingProvider>(builder: (ctx, c, _) {
                return Image.asset(
                  (c.activityMode == ActivityMode.Berjalan)
                      ? AssetImg.walking
                      : AssetImg.running,
                );
              }),
            ),
            const SizedBox(height: 16),
            Text(
              'Pilih jenis aktivitas yang kamu inginkan',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            Consumer<TrackingProvider>(
              builder: (ctx, c, _) {
                final isBerjalan = c.activityMode == ActivityMode.Berjalan;
                final isBerlari = c.activityMode == ActivityMode.Berlari;

                return Row(
                  children: [
                    //* berjalan
                    Flexible(
                      child: GestureDetector(
                        onTap: () =>
                            c.selecActivitytMode(ActivityMode.Berjalan),
                        child: AnimatedContainer(
                          width: double.infinity,
                          padding: EdgeInsets.all(isBerjalan ? 8 : 4),
                          duration: const Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                            borderRadius: isBerjalan
                                ? BorderRadius.circular(100)
                                : BorderRadius.circular(16),
                            color: isBerjalan
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).scaffoldBackgroundColor,
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: Text(
                            ActivityMode.Berjalan.name,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: isBerjalan
                                      ? Theme.of(context)
                                          .scaffoldBackgroundColor
                                      : Theme.of(context).primaryColor,
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    //* berlari
                    Flexible(
                      child: GestureDetector(
                        onTap: () => c.selecActivitytMode(ActivityMode.Berlari),
                        child: AnimatedContainer(
                          width: double.infinity,
                          padding: EdgeInsets.all(isBerlari ? 8 : 4),
                          duration: const Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                            borderRadius: isBerlari
                                ? BorderRadius.circular(100)
                                : BorderRadius.circular(16),
                            color: isBerlari
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).scaffoldBackgroundColor,
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: Text(
                            ActivityMode.Berlari.name,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: isBerlari
                                      ? Theme.of(context)
                                          .scaffoldBackgroundColor
                                      : Theme.of(context).primaryColor,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            //* action button
            Row(
              children: [
                WButton(
                  padding: 12,
                  label: 'Batal',
                  type: ButtonType.OUTLINED,
                  onPressed: cancelActivity,
                ),
                const SizedBox(width: 12),
                Flexible(
                  fit: FlexFit.tight,
                  child: WButton(
                    padding: 12,
                    label: 'Mulai',
                    icon: const Icon(Iconsax.timer_start, size: 18),
                    onPressed: () {
                      Navigator.pop(context);
                      startActivity();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
