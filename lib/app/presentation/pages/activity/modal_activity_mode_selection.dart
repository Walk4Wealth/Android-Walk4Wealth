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
      height: MediaQuery.of(context).size.height * 0.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //* modal title
            // "Pilih mode aktivitas"
            _modalActivity(context),
            const SizedBox(height: 24),

            //* activity mode assets
            _activityModeAssets(),
            const SizedBox(height: 16),

            //* activity mode selection title
            // "Pilih jenis aktivitas yang kamu inginkan"
            Text(
              'Pilih jenis aktivitas yang kamu inginkan',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            //* select button
            Consumer<TrackingProvider>(
              builder: (ctx, c, _) {
                return Row(
                  children: [
                    //* berjalan
                    _selectButton(c, context, mode: ActivityMode.Berjalan),
                    const SizedBox(width: 16),

                    //* berlari
                    _selectButton(c, context, mode: ActivityMode.Berlari),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            //* action button
            Row(
              children: [
                //* cancel button
                _cancelButton(),
                const SizedBox(width: 12),

                //* start button
                _startbutton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _startbutton(BuildContext context) {
    return Flexible(
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
    );
  }

  Widget _cancelButton() {
    return WButton(
      padding: 12,
      label: 'Batal',
      type: ButtonType.OUTLINED,
      onPressed: cancelActivity,
    );
  }

  Widget _selectButton(
    TrackingProvider c,
    BuildContext context, {
    required ActivityMode mode,
  }) {
    bool isSelected = (mode == c.activityMode);

    return Flexible(
      child: GestureDetector(
        onTap: () => c.selecActivitytMode(mode),
        child: AnimatedContainer(
          width: double.infinity,
          padding: EdgeInsets.all(isSelected ? 8 : 4),
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            borderRadius: isSelected
                ? BorderRadius.circular(100)
                : BorderRadius.circular(16),
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).scaffoldBackgroundColor,
            border: Border.all(
              color: Theme.of(context).primaryColor,
            ),
          ),
          child: Text(
            mode.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: isSelected
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Theme.of(context).primaryColor,
                ),
          ),
        ),
      ),
    );
  }

  Widget _activityModeAssets() {
    return Expanded(
      child: Consumer<TrackingProvider>(builder: (ctx, c, _) {
        return Image.asset(
          (c.activityMode == ActivityMode.Berjalan)
              ? AssetImg.walking
              : AssetImg.running,
        );
      }),
    );
  }

  Widget _modalActivity(BuildContext context) {
    return Text(
      'Pilih mode aktivitas',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}
