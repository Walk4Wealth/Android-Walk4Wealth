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
                        Flexible(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Jumlah kalori yang terbakar',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                Text.rich(
                                  TextSpan(
                                    text: '${activity.caloriesBurn ?? 0.0}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                    children: [
                                      TextSpan(
                                          text: '\nkal',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w600,
                                              )),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        //* poin yang didapatkan
                        Flexible(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Poin yang kamu dapatkan',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                Text.rich(
                                  TextSpan(
                                    text: '${activity.pointsEarned ?? 0.0}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                    children: [
                                      TextSpan(
                                          text: '\npoin',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w600,
                                              )),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    //* mode aktivitas
                    Container(
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
                    ),
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
                            title: 'Waktu',
                            data: Text(
                              DateFormat('EEEE, dd MMMM yyyy', 'id').format(
                                DateTime.parse(activity.dateTime ?? ''),
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: 8),

                          //* durasi
                          _buildData(
                            context,
                            title: 'Durasi',
                            data: Text(
                              TimeFormat.formatDuration(
                                  activity.duration ?? Duration.zero),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: 8),

                          //* langkah
                          _buildData(
                            context,
                            title: 'Langkah',
                            data: Text(
                              '${NumberFormat('#,###').format(activity.steps)} langkah',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: 8),

                          //* jarak tempuh
                          _buildData(
                            context,
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.grey.shade600),
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

  Widget _buildData(
    BuildContext context, {
    required String title,
    required Widget data,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey),
        ),
        data,
      ],
    );
  }
}
