import 'package:flutter/material.dart';

import '../../../core/routes/navigate.dart';
import '../../../core/utils/components/w_button.dart';
import '../../../core/utils/strings/asset_img_string.dart';
import 'on_boarding_view.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final _pageController = PageController();
  int _currentView = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            //* on boarding view
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (view) => setState(() {
                    _currentView = view;
                  }),
                  children: const [
                    OnBoardingView(
                      asset: AssetImg.onBoarding1,
                      title: 'Rekam Setiap Langkah Anda',
                      subtitle:
                          'Pantau rute lari dan jalan Anda secara real-time, simpan pencapaian Anda, dan lihat progres kesehatan Anda',
                    ),
                    OnBoardingView(
                      asset: AssetImg.onBoarding2,
                      title: 'Kumpulkan Poin dari Setiap Kilometer',
                      subtitle:
                          'Setiap langkah yang Anda ambil menghasilkan poin yang bisa Anda tukarkan dengan hadiah menarik seperti pulsa dan voucher belanja',
                    ),
                    OnBoardingView(
                      asset: AssetImg.onBoarding3,
                      title: 'Mulai Hidup Sehat Sekarang',
                      subtitle:
                          'Buat hidup sehat lebih menyenangkan dengan hadiah yang Anda dapatkan. Ayo, mulailah perjalanan menuju hidup sehat hari ini!',
                    ),
                  ],
                ),
              ),
            ),

            //* dot indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  height: 8,
                  width: (_currentView == index) ? 20 : 8,
                  margin: const EdgeInsets.only(right: 8),
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: (_currentView == index)
                        ? Colors.black54
                        : Colors.black12,
                    borderRadius: BorderRadius.circular(50),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),

            //* button register
            WButton(
              expand: true,
              label: 'Join Sekarang',
              margin: const EdgeInsets.symmetric(horizontal: 16),
              onPressed: () => Navigator.pushNamed(context, To.REGISTER),
            ),
            const SizedBox(height: 12),

            //* button login
            WButton(
              expand: true,
              label: 'Masuk',
              type: ButtonType.OUTLINED,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              onPressed: () => Navigator.pushNamed(context, To.LOGIN),
            ),
          ],
        ),
      ),
    );
  }
}
