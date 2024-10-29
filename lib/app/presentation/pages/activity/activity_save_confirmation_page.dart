import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/components/w_button.dart';
import '../../../core/utils/strings/asset_img_string.dart';
import '../../providers/activity_provider.dart';

class ActivitySaveConfirmPage extends StatelessWidget {
  const ActivitySaveConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //* gif
                Image.asset(
                  AssetImg.activitySaved,
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),

                //* title
                Text(
                  'Selamat aktivitas kamu berhasil disimpan',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),

                Consumer<ActivityProvider>(builder: (ctx, c, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //* kalori yang terbakar
                      _buildMainData(
                        context,
                        title: 'Kalori yang terbakar',
                        data: c.activity?.caloriesBurn,
                        unit: 'kal',
                        icon: AssetImg.iconFire,
                      ),
                      const SizedBox(width: 16),

                      //* poin yang didapatkan
                      _buildMainData(
                        context,
                        title: 'Poin yang didapatkan',
                        data: c.activity?.pointsEarned,
                        unit: 'poin',
                        icon: AssetImg.iconCoin,
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 24),
                WButton(
                  label: 'Lihat aktivitas',
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await context.read<ActivityProvider>().getActivity();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainData(
    BuildContext context, {
    required String title,
    required num? data,
    required String unit,
    required String icon,
  }) {
    return Flexible(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  icon,
                  width: 45,
                  height: 40,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(data ?? 0).toInt()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      unit,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
