import 'package:flutter/material.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({
    super.key,
    required this.asset,
    required this.title,
    required this.subtitle,
  });

  final String asset;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //* ilustrasi
          Padding(
            padding: const EdgeInsets.all(16),
            child: Image.asset(
              asset,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),

          //* title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 8),

          //* subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
