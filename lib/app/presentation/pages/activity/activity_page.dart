import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../core/enums/tracking_state.dart';
import '../../../core/utils/components/w_app_bar.dart';
import '../../../core/utils/dialog/w_dialog.dart';
import '../../providers/tracking_provider.dart';
import 'activity_map_view.dart';
import 'activity_action_button.dart';
import 'activity_panel_view.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  late TrackingProvider _trackingC;

  @override
  void initState() {
    super.initState();
    _trackingC = context.read<TrackingProvider>();

    if (_trackingC.trackingState == TrackingState.INIT ||
        _trackingC.trackingState == TrackingState.STOP) {
      // init map controller
      _trackingC.initMapController(MapController());
      // logger
      log('MapController di inisiasi pada saat initState halaman activity_page');
      // get current location
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _trackingC.getCurrentLocation(),
      );
    }
  }

  //* open dialog
  void _openRemoveAcitvityDialog(
    BuildContext context,
    TrackingProvider c,
  ) async {
    c.closePanel();
    await WDialog.showDialog(
      context,
      icon: const Icon(Iconsax.stop_circle),
      title: 'Hapus aktivitas',
      message:
          'Apakah kamu yakin ingin menghentikan dan menghapus aktivitas ini?',
      actions: [
        DialogAction(
          label: 'Lanjutkan',
          onPressed: () => _resumeTracking(context, c),
        ),
        DialogAction(
          label: 'Hapus',
          isDefaultAction: true,
          onPressed: () => _stopTracking(context, c),
        ),
      ],
    );
  }

  //* resume activity
  void _resumeTracking(BuildContext context, TrackingProvider c) {
    c.resumeTracking();
    Navigator.pop(context); // tutup dialog
    WDialog.activitySnackbar(context, c.trackingMessage!, c.trackingState);
  }

  //* stop activity
  void _stopTracking(BuildContext context, TrackingProvider c) async {
    await c.stopTracking();
    c.resetTrackingData();
    if (context.mounted) {
      Navigator.of(context).pop(); // tutup dialog
      Navigator.of(context).pop(); // keluar halaman
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final actionButtonHeight = (MediaQuery.of(context).size.height * 0.1) +
        MediaQuery.of(context).padding.bottom;
    final appBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;

    return Scaffold(
      appBar: WAppBar(
        titleWidget: Consumer<TrackingProvider>(
          builder: (ctx, c, _) => Text(c.activityMode.name.toUpperCase()),
        ),
        actions: [
          //* button hapus tracking
          Consumer<TrackingProvider>(builder: (ctx, c, _) {
            if (c.trackingState == TrackingState.PAUSE ||
                c.trackingState == TrackingState.FAILURE) {
              return TextButton(
                onPressed: () => _openRemoveAcitvityDialog(context, c),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Hapus'),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SlidingUpPanel(
              minHeight: 0.0,
              parallaxEnabled: true,
              controller: _trackingC.panelController,
              panel: const ActivityPanelView(),
              color: Theme.of(context).scaffoldBackgroundColor,
              maxHeight: deviceHeight - actionButtonHeight - appBarHeight,
              //* map view
              body: ActivityMapView(actionButtonHeight),
            ),
          ),
          //* start/pause/resume/stop
          ActivityActionButton(actionButtonHeight),
        ],
      ),
      //* button open panel
      floatingActionButton: Consumer<TrackingProvider>(
        builder: (ctx, c, _) {
          if (c.trackingState == TrackingState.TRACK ||
              c.trackingState == TrackingState.PAUSE ||
              c.trackingState == TrackingState.FAILURE) {
            return FloatingActionButton.small(
              heroTag: 'panel',
              elevation: 0,
              highlightElevation: 0,
              onPressed: c.panelToggle,
              child: const Icon(Iconsax.timer_start),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
