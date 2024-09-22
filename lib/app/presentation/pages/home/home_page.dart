import 'package:flutter/material.dart';
import '../../../core/routes/navigate.dart';
import '../../../core/utils/components/w_button.dart';
import '../../../core/utils/strings/asset_img_string.dart';
import 'home_mini_profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // mini profil
          const HomeMiniProfile(),

          // konten history
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //* aktivitas terakhir
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Aktivitas Terakhir',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_forward, size: 15),
                            iconAlignment: IconAlignment.end,
                            label: const Text(
                              'Semua aktivitas',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: Image.asset(AssetImg.noActivity),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Kamu belum melakukan aktivitas apapun',
                              ),
                              const SizedBox(height: 16),
                              WButton(
                                label: 'Mulai Sekarang',
                                onPressed: () {
                                  Navigator.pushNamed(context, To.ACTIVITY);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
