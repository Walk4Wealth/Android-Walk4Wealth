import 'package:flutter/material.dart';

import '../../../core/utils/components/w_button.dart';
import '../../../core/utils/strings/asset_img_string.dart';

class ModalActivityAccessLocationAllTime extends StatelessWidget {
  const ModalActivityAccessLocationAllTime({
    super.key,
    required this.cancelActivity,
    required this.openAppSettings,
  });

  final VoidCallback cancelActivity;
  final VoidCallback openAppSettings;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //* title
              _title(context),

              //* asset intruksi
              _intructionAsset(),

              //* subtitle (edukasi user)
              _subtitleEducation(context),

              //* subtitle (tutorial)
              _subtitleTutorial(context),

              //* action button
              _actionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Text(
      'Aktifkan izin lokasi selamanya',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _intructionAsset() {
    return Image.asset(
      AssetImg.accessLocationAllTime,
      width: double.infinity,
      height: 200,
    );
  }

  Widget _subtitleEducation(BuildContext context) {
    return Text(
      'Aplikasi harus mendapatkan izin lokasi selamanya untuk bisa melakukan aktivitas dan berjalan dilatar belakang',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _subtitleTutorial(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Masuk pengaturan aplikasi -> Izin lokasi -> ',
        style: Theme.of(context).textTheme.bodySmall,
        children: [
          TextSpan(
            text: 'Izinkan lokasi sepanjang waktu',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          TextSpan(
            text: ' untuk mengaktifkan mode latar belakang',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _actionButton() {
    return Row(
      children: [
        //* cancel button
        WButton(
          label: 'Batal',
          padding: 12,
          bold: false,
          type: ButtonType.OUTLINED,
          onPressed: cancelActivity,
        ),
        const SizedBox(width: 16),

        //* setting button
        Flexible(
          fit: FlexFit.tight,
          child: WButton(
            label: 'Buka pengaturan',
            icon: const Icon(Icons.settings),
            padding: 12,
            onPressed: openAppSettings,
          ),
        ),
      ],
    );
  }
}
