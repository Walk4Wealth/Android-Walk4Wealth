import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../core/enums/tracking_state.dart';
import '../../../core/utils/components/w_app_bar.dart';
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

    if (_trackingC.trackingState == TrackingState.INIT) {
      // init map controller
      _trackingC.initMapController(MapController());
      // get current location
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _trackingC.getCurrentLocation();
        _trackingC.checkLocationAllowAllTime();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final actionButtonHeight = MediaQuery.of(context).size.height * 0.1;
    final appBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;

    return Scaffold(
      appBar: WAppBar(
        titleWidget: Consumer<TrackingProvider>(
          builder: (ctx, c, _) => Text(c.activityMode.name.toUpperCase()),
        ),
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
          if (c.trackingState == TrackingState.TRACK) {
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
