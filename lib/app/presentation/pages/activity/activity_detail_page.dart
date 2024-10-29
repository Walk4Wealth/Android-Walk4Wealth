import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/enums/activity_mode.dart';
import '../../../core/formatter/time_formatter.dart';
import '../../../core/utils/components/capture_map.dart';
import '../../../core/utils/components/w_app_bar.dart';
import '../../../core/utils/strings/asset_img_string.dart';
import '../../../domain/entity/activity.dart';

class ActivityDetailPage extends StatelessWidget {
  const ActivityDetailPage(this.activity, {super.key});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final mileageInKm = (activity.mileage ?? 0) / 1000;
    return Scaffold(
      appBar: const WAppBar(title: 'Detail aktvitas'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //* capture map
            SizedBox(
              width: double.infinity,
              height: 180,
              child: CaptureMap(
                showPreview: true,
                points: activity.coordinates ?? [],
                scrollGestureEnabled: false,
              ),
            ),
            const SizedBox(height: 8),

            //* data
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //* title
                    Text(
                      'Berikut adalah pantauan aktivitas kamu',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        //* kalori yang terbakar
                        _buildMainData(
                          context,
                          title: 'Kalori yang terbakar',
                          data: activity.caloriesBurn,
                          unit: 'kal',
                          icon: AssetImg.iconFire,
                        ),
                        const SizedBox(width: 16),

                        //* poin yang didapatkan
                        _buildMainData(
                          context,
                          title: 'Poin yang didapatkan',
                          data: activity.pointsEarned,
                          unit: 'poin',
                          icon: AssetImg.iconCoin,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    //* mode aktivitas
                    _activityMode(context),
                    const SizedBox(height: 16),

                    //* data
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          //* waktu
                          _buildData(
                            context,
                            icon: Icons.watch_later_outlined,
                            title: 'Waktu',
                            data: Text(
                              DateFormat('EEEE, dd MMMM yyyy', 'id').format(
                                DateTime.parse(activity.dateTime ?? '')
                                    .toLocal(),
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: 10),

                          //* durasi
                          _buildData(
                            context,
                            icon: Icons.timelapse_sharp,
                            title: 'Durasi',
                            data: Text(
                              TimeFormat.formatDuration(
                                  activity.duration ?? Duration.zero),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: 10),

                          //* langkah
                          _buildData(
                            context,
                            icon: Icons.directions_walk_outlined,
                            title: 'Langkah',
                            data: Text(
                              '${NumberFormat('#,###').format(activity.steps)} langkah',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: 10),

                          //* jarak tempuh
                          _buildData(
                            context,
                            icon: Icons.route_rounded,
                            title: 'Jarak tempuh',
                            data: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${mileageInKm.toStringAsFixed(1)} km',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  '${NumberFormat('#,###').format(activity.mileage)} m',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityMode(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
              backgroundColor: Colors.blue.shade50,
              radius: 30,
              child: Image.asset(
                activity.mode == ActivityMode.Berjalan
                    ? AssetImg.walking
                    : AssetImg.running,
                fit: BoxFit.contain,
              )),
          Text(
            (activity.mode?.name ?? '').toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildMainData(
    BuildContext context, {
    required String title,
    required num? data,
    required String unit,
    required String icon,
  }) {
    double fontSize = ((data ?? 0) >= 10000) ? 26 : 32;

    return Flexible(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  icon,
                  width: 45,
                  height: 40,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      NumberFormat('#,###').format(data ?? 0),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: fontSize,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      unit,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildData(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget data,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey),
        ),
        Flexible(
          fit: FlexFit.tight,
          child: Align(alignment: Alignment.centerRight, child: data),
        ),
      ],
    );
  }
}
