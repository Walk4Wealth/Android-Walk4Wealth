import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/activity_mode.dart';
import '../../../core/enums/tracking_state.dart';
import '../../../core/routes/navigate.dart';
import '../../../core/utils/strings/asset_img_string.dart';
import '../../providers/tracking_provider.dart';

class HomeCurrentActivity extends StatelessWidget {
  const HomeCurrentActivity({super.key});

  void _navigateToActivityPage(BuildContext context) {
    Navigator.pushNamed(context, To.ACTIVITY);
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 100.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: () => _navigateToActivityPage(context),
          highlightColor: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 12,
              left: 8,
              right: 16,
            ),
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(radius)),
            child: LayoutBuilder(builder: (_, size) {
              return Consumer<TrackingProvider>(builder: (ctx, c, _) {
                return Row(
                  children: [
                    //* logo aktivitas
                    _activityLogo(size, c),
                    const SizedBox(width: 12),

                    Flexible(
                      fit: FlexFit.tight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //* mode aktivitas
                          _activityMode(c, context),

                          //* tracking duration
                          _trackingDuration(c, context),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),

                    //* jarak tempuh
                    _trackingDistance(c, context),
                  ],
                );
              });
            }),
          ),
        ),
      ),
    );
  }

  Widget _activityMode(TrackingProvider c, BuildContext context) {
    return Text(
      c.activityMode.name.toUpperCase(),
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _trackingDuration(TrackingProvider c, BuildContext context) {
    return Text(
      c.stringTimer,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: Colors.grey.shade800),
    );
  }

  Widget _trackingDistance(TrackingProvider c, BuildContext context) {
    return Text.rich(
      TextSpan(
        text: NumberFormat('#,###').format(
          c.mileage.toInt(),
        ),
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontWeight: FontWeight.w600),
        children: [
          TextSpan(
              text: ' m',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  Widget _activityLogo(BoxConstraints size, TrackingProvider c) {
    return Container(
      height: 50,
      width: size.maxWidth * 0.2,
      decoration: BoxDecoration(
        color: c.trackingState == TrackingState.PAUSE
            ? Colors.amber.shade300
            : Colors.blue.shade100,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: c.trackingState == TrackingState.PAUSE
            ? const Icon(
                Icons.pause,
                color: Colors.white,
              )
            : Image.asset(
                c.activityMode == ActivityMode.Berjalan
                    ? AssetImg.walking
                    : AssetImg.running,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
