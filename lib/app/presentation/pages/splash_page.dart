import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).padding.top + 24),
          child: Column(
            children: [
              //* section 1 (logo udinus & bima)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //* logo udinus
                  Image.asset(
                    AssetImg.logoUdinus,
                    height: 55,
                    fit: BoxFit.contain,
                  ),
                  //* logo bima
                  Image.asset(
                    AssetImg.logoBima,
                    height: 45,
                    fit: BoxFit.contain,
                  ),
                ],
              ),

              //* section 2 (app logo)
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //* logo aplikasi
                      Image.asset(
                        AssetImg.logoW4wPrimary,
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 12),

                      //* title W4W
                      Text.rich(
                        TextSpan(
                          text: 'W4W',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                text: '\nWalk For Wealth',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              //* section 3 (app version)
              Text('Version 1.0.0',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
