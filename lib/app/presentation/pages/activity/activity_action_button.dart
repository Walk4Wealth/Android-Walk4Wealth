import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/location_permission_state.dart';
import '../../../core/enums/location_state.dart';
import '../../../core/enums/tracking_state.dart';
import '../../../core/routes/navigate.dart';
import '../../../core/utils/dialog/w_dialog.dart';
import '../../providers/tracking_provider.dart';
import 'modal_activity_access_location_all_time.dart';
import 'modal_activity_mode_selection.dart';
import 'modal_activity_stop_confirmation.dart';

class ActivityActionButton extends StatelessWidget {
  const ActivityActionButton(this.height, {super.key});

  final double height;

  //* start tracking
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
          cancelActivity: () {
            Navigator.of(context).pop(); // tutup dialog
            Navigator.of(context).pop(); // keluar halaman
          },
          startActivity: () async {
            if (c.isLocationAllowAllTime) {
              c.startCountdown(context, () async {
                await c.startTracking();
                if (context.mounted) {
                  WDialog.activitySnackbar(
                    context,
                    c.trackingMessage ?? 'Aktivitas dimulai',
                    c.trackingState,
                  );
                }
              });
            } else {
              // show modal bottom sheet allow location all time
              showModalBottomSheet(
                context: context,
                enableDrag: false,
                isDismissible: false,
                builder: (context) {
                  return ModalActivityAccessLocationAllTime(
                    cancelActivity: () {
                      Navigator.of(context).pop(); // tutup dialog
                      Navigator.of(context).pop(); // keluar halaman
                    },
                    openAppSettings: () async {
                      Navigator.of(context).pop(); // tutup dialog
                      Navigator.of(context).pop(); // keluar halaman
                      await c.openAppSettings();
                    },
                  );
                },
              );
            }
          },
        ),
      );
    }
  }

  //* stop tracking
  _stop(BuildContext context, TrackingProvider c) {
    if (c.trackingState == TrackingState.TRACK) {
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
            Navigator.pop(context); // tututp dialog
            c.openPanel();
          },
          stopActivity: () async {
            await c.stopTracking();
            if (context.mounted) {
              Navigator.pop(context); // tutup dialog
              Navigator.pushNamedAndRemoveUntil(
                context,
                To.ACTIVITY_SAVE,
                (route) => route.isFirst,
              );
            }
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightButton = height - 8;

    return Container(
      height: height,
      width: double.infinity,
      color: Colors.white,
      //* action button
      child: Consumer<TrackingProvider>(
        builder: (ctx, c, _) {
          bool disabled =
              c.permissionState != LocationPermissionState.ALLOWED ||
                  c.getLocationState != GetLocationState.SUCCESS;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //* start button
              if (c.trackingState == TrackingState.INIT)
                _startButton(heightButton, disabled, context, c),

              //* stop button
              if (c.trackingState == TrackingState.TRACK)
                _stopButton(heightButton, context, c),
            ],
          );
        },
      ),
    );
  }

  Widget _startButton(double heightButton, bool disabled, BuildContext context,
      TrackingProvider c) {
    return SizedBox(
      height: heightButton,
      child: ElevatedButton(
        onPressed: disabled ? null : () => _tracking(context, c),
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
          backgroundColor:
              c.trackingState == TrackingState.TRACK ? Colors.white : null,
        ),
        child: const Text('Mulai'),
      ),
    );
  }

  Widget _stopButton(
      double heightButton, BuildContext context, TrackingProvider c) {
    return SizedBox(
      height: heightButton,
      child: ElevatedButton(
        onPressed: () async => _stop(context, c),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: const CircleBorder(),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
        ),
        child: const Text('Stop'),
      ),
    );
  }
}
