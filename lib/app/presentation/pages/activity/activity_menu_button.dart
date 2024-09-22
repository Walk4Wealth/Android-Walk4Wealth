import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../core/enum/location_permission_state.dart';
import '../../../core/enum/location_state.dart';
import '../../../core/enum/tracking_state.dart';
import '../../providers/tracking_provider.dart';

class ActivityMenuButton extends StatelessWidget {
  const ActivityMenuButton({
    super.key,
    required this.mapController,
    required this.panelController,
  });

  final MapController mapController;
  final PanelController panelController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: kBottomNavigationBarHeight,
      ),
      child: Consumer<TrackingProvider>(
        builder: (ctx, c, _) {
          final disabled =
              c.permissionState != LocationPermissionState.ALLOWED ||
                  c.getLocationState != GetLocationState.SUCCESS;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //* button start / pause
              GestureDetector(
                onTap: () => _activity(c),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: disabled
                        ? Colors.grey.shade300
                        : c.trackingState == TrackingState.TRACK
                            ? Theme.of(context).scaffoldBackgroundColor
                            : Theme.of(context).primaryColor,
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: c.trackingState == TrackingState.TRACK
                      ? Icon(
                          Icons.pause,
                          color: disabled
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                        )
                      : Text(
                          'Mulai',
                          style: TextStyle(
                            color: disabled
                                ? Colors.grey
                                : Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                ),
              ),

              //* open/close panel
              (c.trackingState == TrackingState.INIT ||
                      c.trackingState == TrackingState.LOADING)
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: GestureDetector(
                        onTap: () async {
                          if (panelController.isPanelClosed) {
                            await panelController.open();
                            return;
                          }
                          if (panelController.isPanelOpen) {
                            await panelController.close();
                            return;
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder: (c, a) =>
                                ScaleTransition(scale: a, child: c),
                            child: Icon(
                              panelController.isPanelOpen
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              key: ValueKey<bool>(panelController.isPanelOpen),
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      ),
                    )
            ],
          );
        },
      ),
    );
  }

  void _activity(TrackingProvider c) async {
    if (c.trackingState == TrackingState.INIT) {
      // start tracking
      await c.startTracking(mapController);
      // open panel
      await panelController.open();
      return;
    }
    if (c.trackingState == TrackingState.TRACK) {
      // pause tracking
      c.pauseTracking();
      // open panel
      await panelController.open();
      return;
    }
  }
}
