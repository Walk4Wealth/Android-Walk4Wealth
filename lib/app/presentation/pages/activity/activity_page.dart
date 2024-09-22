import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../core/utils/components/w_app_bar.dart';
import '../../providers/tracking_provider.dart';
import 'activity_map_view.dart';
import 'activity_menu_button.dart';
import 'panel_view.dart';
import 'panel_drag_handle.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  late MapController _mapController;
  late PanelController _panelController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _panelController = PanelController();

    Future.microtask(
      // ignore: use_build_context_synchronously
      () => context.read<TrackingProvider>().getCurrentLocation(),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        title: 'Joging',
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
            foregroundColor: const WidgetStatePropertyAll(Colors.red),
            backgroundColor: WidgetStatePropertyAll(Colors.red.shade50),
            overlayColor: const WidgetStatePropertyAll(Colors.white),
          ),
          child: const Text('Keluar'),
        ),
      ),
      body: Stack(
        children: [
          // view
          SlidingUpPanel(
            controller: _panelController,
            maxHeight: MediaQuery.of(context).size.height * 0.6,
            minHeight: kBottomNavigationBarHeight +
                MediaQuery.of(context).padding.bottom,
            panel: const PanelView(),
            header: const PanelDragHandle(),
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            body: ActivityMapView(_mapController),
          ),

          // menu controller
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ActivityMenuButton(
              mapController: _mapController,
              panelController: _panelController,
            ),
          ),
        ],
      ),
    );
  }
}
