// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/enums/tracking_state.dart';
import '../../providers/tracking_provider.dart';
import 'home_current_activity.dart';
import 'home_list_activity.dart';
import 'home_mini_profile.dart';
import 'home_point_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          //* mini profil
          const HomeMiniProfile(),
          const SizedBox(height: 16),

          //* container poin
          const HomePointContainer(),
          const SizedBox(height: 16),

          //* aktivitas terkini
          Consumer<TrackingProvider>(
            builder: (ctx, c, _) {
              if (c.trackingState == TrackingState.TRACK) {
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HomeCurrentActivity(),
                    SizedBox(height: 16),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),

          //* list activity
          const Expanded(child: HomeListActivity()),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
