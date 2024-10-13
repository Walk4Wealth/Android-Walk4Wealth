import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/location_permission_state.dart';
import '../../../core/enums/location_state.dart';
import '../../../core/enums/tracking_state.dart';
import '../../../core/routes/navigate.dart';
import '../../../core/utils/dialog/w_dialog.dart';
import '../../providers/tracking_provider.dart';
import 'modal_activity_mode_selection.dart';
import 'modal_activity_stop_confirmation.dart';

class ActivityActionButton extends StatelessWidget {
  const ActivityActionButton(this.height, {super.key});

  final double height;

  //* show alert dialog when app is first opened
  void _showAlertDialog(BuildContext context, TrackingProvider c) {
    if (c.isShowAlertDialog) {
      WDialog.showDialog(
        context,
        icon: const Icon(Icons.warning_amber_rounded),
        title: 'Sebelum memulai',
        message:
            'Aktivitas tracking membutuhkan layanan GPS dan koneksi internet yang aktif. Jika salah satu atau keduanya mati, aktivitas tracking akan dijeda secara otomatis hingga layanan tersebut kembali aktif.',
        actions: [
          DialogAction(
            label: 'Mengerti',
            isDefaultAction: true,
            onPressed: () {
              // set key
              c.setKeyActivityAlertDialog();
              Navigator.pop(context); // tutup dialog
              _tracking(context, c);
            },
          ),
        ],
      );
    } else {
      // jika aplikasi sudah pernah menampilkan alert dialog maka akan langsung memulai tracking
      _tracking(context, c);
    }
  }

  //* start/pause tracking
  void _tracking(BuildContext context, TrackingProvider c) {
    if (c.trackingState == TrackingState.INIT ||
        c.trackingState == TrackingState.STOP) {
      //* select mode
      showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // pilih mode aktivitas kemudian start aktivitas
        builder: (context) => ModalActivityModeSelection(
          cancelActivity: () => Navigator.pop(context),
          startActivity: () async {
            await c.startTracking();
            if (context.mounted) {
              WDialog.activitySnackbar(context,
                  c.trackingMessage ?? 'Aktivitas dimulai', c.trackingState);
            }
          },
        ),
      );
      return;
    }
    //* pause tracking
    if (c.trackingState == TrackingState.TRACK) {
      c.pauseTracking();
      WDialog.activitySnackbar(context, c.trackingMessage!, c.trackingState);
      return;
    }
  }

  //* resume tracking
  _resume(BuildContext context, TrackingProvider c) {
    if (c.trackingState == TrackingState.PAUSE) {
      c.resumeTracking();
      WDialog.activitySnackbar(context, c.trackingMessage!, c.trackingState);
      return;
    }
  }

  //* stop tracking
  _stop(BuildContext context, TrackingProvider c) {
    if (c.trackingState == TrackingState.PAUSE) {
      c.closePanel();
      c.calculateStep();

      //* stop confimation
      showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // konfirmasi untuk menyelesaikan aktivitas
        builder: (context) => ModalActivityStopConfirmation(
          resumeActivity: () {
            c.resumeTracking();
            Navigator.pop(context); // tutup dialog
            WDialog.activitySnackbar(
                context, c.trackingMessage!, c.trackingState);
          },
          stopActivity: () {
            c.stopTracking();
            Navigator.pop(context); // tutup dialog
            Navigator.pushNamedAndRemoveUntil(
              context,
              To.ACTIVITY_SAVE,
              (route) => route.isFirst,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final heightButton = height - MediaQuery.of(context).padding.bottom;

    return Container(
      height: height,
      width: double.infinity,
      color: Colors.white,
      //* action button
      child: Consumer<TrackingProvider>(
        builder: (ctx, c, _) {
          final disabled =
              c.permissionState != LocationPermissionState.ALLOWED ||
                  c.getLocationState != GetLocationState.SUCCESS;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (c.trackingState != TrackingState.PAUSE)
                //* start/pause button
                SizedBox(
                  height: heightButton,
                  child: ElevatedButton(
                    onPressed:
                        disabled ? null : () => _showAlertDialog(context, c),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: CircleBorder(
                        side: BorderSide(
                          color: disabled
                              ? Colors.grey.shade700
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                      backgroundColor: c.trackingState == TrackingState.TRACK
                          ? Colors.white
                          : null,
                    ),
                    child: c.trackingState == TrackingState.TRACK
                        ? Icon(
                            Icons.pause,
                            color: c.trackingState == TrackingState.TRACK
                                ? Theme.of(context).primaryColor
                                : null,
                          )
                        : const Text('Mulai'),
                  ),
                ),
              if (c.trackingState == TrackingState.PAUSE)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //* resume button
                    SizedBox(
                      height: heightButton,
                      child: ElevatedButton(
                        onPressed: () async => _resume(context, c),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: const CircleBorder(),
                        ),
                        child: const Text('Lanjutkan'),
                      ),
                    ),

                    //* stop button
                    SizedBox(
                      height: heightButton,
                      child: ElevatedButton(
                        onPressed: () async => _stop(context, c),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          foregroundColor: Theme.of(context).primaryColor,
                          backgroundColor: Colors.white,
                          shape: CircleBorder(
                            side: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        child: const Text('Selesai'),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
