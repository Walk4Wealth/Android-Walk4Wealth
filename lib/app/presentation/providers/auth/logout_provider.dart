import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/cache/cache_manager.dart';
import '../../../core/routes/navigate.dart';
import '../../../core/utils/dialog/w_dialog.dart';
import '../../../domain/usecases/auth/logout_user.dart';
import '../../../domain/usecases/user/delete_user.dart';

class LogoutProvider extends ChangeNotifier {
  final LogoutUser _logoutUser;
  final DeleteUser _deleteUser;
  final CacheManager _cacheManager;

  LogoutProvider({
    required LogoutUser logoutUser,
    required DeleteUser deleteUser,
    required CacheManager cacheManager,
  })  : _logoutUser = logoutUser,
        _deleteUser = deleteUser,
        _cacheManager = cacheManager;

  //* logout
  void _logout(BuildContext context) async {
    WDialog.showLoading(context);
    await Future.delayed(const Duration(seconds: 3), () async {
      if (context.mounted) {
        final logout = await _logoutUser.call();

        logout.fold(
          (failure) {
            WDialog.closeLoading();
            WDialog.snackbar(context, message: failure.message);
          },
          (_) {
            // semua data penyimpanan lokal seperti cache dan shared prefs akan dihapus
            // token, user, dan cache manager
            _deleteUser.call();
            _cacheManager.clear();

            // action logout
            WDialog.closeLoading();
            Navigator.pushNamedAndRemoveUntil(
              context,
              To.ON_BOARDING,
              (route) => false,
            );
          },
        );
      }
    });
  }

  void logoutPopUp(BuildContext context) {
    WDialog.showDialog(
      context,
      withAnimation: Platform.isAndroid ? true : false,
      title: const Text('Logout'),
      message: 'Anda yakin ingin keluar dari akun ini?',
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _logout(context);
          },
          child: const Text('Ya'),
        ),
      ],
    );
  }
}
