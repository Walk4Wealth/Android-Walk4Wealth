import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/strings/asset_img_string.dart';
import '../providers/auth/load_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoadProvider>().checkAuthentication(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircleAvatar(
          radius: 80,
          backgroundImage: const AssetImage(AssetImg.logoUdinus),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
