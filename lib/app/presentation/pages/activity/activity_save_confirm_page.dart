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
    return Scaffold(
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //* poin yang didapatkan
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Poin yang kamu dapatkan',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Consumer<ActivityProvider>(
                            builder: (ctx, c, _) {
                              return Text.rich(
                                TextSpan(
                                  text: '${c.activity?.pointsEarned ?? 0}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                  children: [
                                    TextSpan(
                                        text: '\nPoin',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w600,
                                            )),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  //* kalori yang terbakar
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Jumlah kalori yang terbakar',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Consumer<ActivityProvider>(
                            builder: (ctx, c, _) {
                              return Text.rich(
                                TextSpan(
                                  text:
                                      '${(c.activity?.caloriesBurn ?? 0).toInt()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                  children: [
                                    TextSpan(
                                        text: '\nkal',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w600,
                                            )),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
    );
  }
}
