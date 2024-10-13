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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, To.ACTIVITY),
          highlightColor: Colors.white,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 12,
              left: 8,
              right: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            child: LayoutBuilder(builder: (_, size) {
              return Consumer<TrackingProvider>(builder: (ctx, c, _) {
                return Row(
                  children: [
                    //* logo aktivitas
                    Container(
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
                    ),
                    const SizedBox(width: 12),

                    Flexible(
                      fit: FlexFit.tight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //* mode aktivitas
                          Text(
                            c.activityMode.name.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),

                          //* tracking time
                          Text(
                            c.stringTimer,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey.shade800),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),

                    //* jarak tempuh
                    Text.rich(
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
                    ),
                  ],
                );
              });
            }),
          ),
        ),
      ),
    );
  }
}
