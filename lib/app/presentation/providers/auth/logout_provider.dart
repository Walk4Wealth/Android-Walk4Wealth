import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../core/cache/cache_manager.dart';
import '../../../core/enums/tracking_state.dart';
import '../../../core/routes/navigate.dart';
import '../../../core/utils/dialog/w_dialog.dart';
import '../../../domain/usecases/auth/logout_user.dart';
import '../../../domain/usecases/user/delete_user.dart';
import '../tracking_provider.dart';

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
            WDialog.showDialog(
              context,
              title: 'Terjadi Kesalahan',
              message: failure.message,
              icon: const Icon(Iconsax.warning_2),
              actions: [
                DialogAction(
                  label: 'Kembali',
                  onPressed: () => Navigator.pop(context),
                )
              ],
            );
          },
          (_) async {
            // semua data penyimpanan lokal seperti cache dan shared prefs akan dihapus
            // token, user, dan cache manager
            await _deleteUser.call();
            _cacheManager.clear();

            // action logout
            WDialog.closeLoading();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                To.ON_BOARDING,
                (route) => false,
              );
            }
          },
        );
      }
    });
  }

  void logoutPopUp(BuildContext context) {
    final trackingC = context.read<TrackingProvider>();

    // izinkan logout ketika aktivitas sedang tidak dilakukan atau di stop
    if (trackingC.trackingState == TrackingState.INIT ||
        trackingC.trackingState == TrackingState.STOP) {
      WDialog.showDialog(
        context,
        title: 'Permintaan Keluar',
        message: 'Apakah kamu yakin ingin keluar dari akun ini?',
        icon: const Icon(Iconsax.logout),
        actions: [
          DialogAction(
            label: 'Batal',
            onPressed: () => Navigator.pop(context),
          ),
          DialogAction(
            label: 'Keluar',
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              _logout(context);
            },
          )
        ],
      );
    } else {
      WDialog.showDialog(
        context,
        title: 'Permintaan Keluar',
        message:
            'Maaf kamu tidak bisa keluar dari akun ini saat aktivitas sedang berjalan',
        icon: const Icon(Iconsax.smileys),
        actions: [
          DialogAction(
            label: 'Kembali',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    }
  }
}
