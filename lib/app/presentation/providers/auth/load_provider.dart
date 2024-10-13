import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../activity_provider.dart';
import '../user_provider.dart';
import '../../../core/routes/navigate.dart';
import '../../../domain/usecases/auth/check_authentication.dart';

class LoadProvider extends ChangeNotifier {
  final CheckAuthentication _authentication;

  LoadProvider({
    required CheckAuthentication authentication,
  }) : _authentication = authentication;

  // cek autentikasi
  void checkAuthentication(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3), () {
      final isAuthenticated = _authentication.call();

      if (context.mounted) {
        if (isAuthenticated) {
          // get data
          context.read<UserProvider>().getProfile();
          context.read<ActivityProvider>().getActivity();
          Navigator.pushNamedAndRemoveUntil(
            context,
            To.MAIN,
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            To.ON_BOARDING,
            (route) => false,
          );
        }
      }
    });
  }
}
