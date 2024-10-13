import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/routes/navigate.dart';
import '../../core/utils/strings/asset_img_string.dart';
import '../../domain/entity/activity.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard(
    this.activity, {
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isOne,
  });

  final Activity activity;
  final bool isFirst;
  final bool isLast;
  final bool isOne;

  @override
  Widget build(BuildContext context) {
    final radius = isOne
        ? BorderRadius.circular(8)
        : BorderRadius.vertical(
            top: isFirst ? const Radius.circular(8) : Radius.zero,
            bottom: isLast ? const Radius.circular(8) : Radius.zero,
          );
    final mileageInKm = (activity.mileage ?? 0) / 1000;

    return Material(
      color: Colors.white,
      borderRadius: radius,
      //* navigasi ke halaman detail aktivitas
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          To.ACTIVITY_DETAIL,
          arguments: activity,
        ),
        borderRadius: radius,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  //* foto
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue.shade50,
                    child: Image.asset(
                      (activity.activityId == 1)
                          ? AssetImg.walking
                          : AssetImg.running,
                    ),
                  ),
                  const SizedBox(width: 24),

                  //* data
                  Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //* tanggal
                        Text(
                          DateFormat('dd MMMM', 'id').format(
                            DateTime.parse(activity.dateTime ?? ''),
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 8),

                        //* jarak tempuh (meter)
                        Text(
                          '${NumberFormat('#,###').format(activity.mileage)} meter',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //* jarak tempuh (kilometer)
                            Text(
                              '${mileageInKm.toStringAsFixed(1)} km',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                            const SizedBox(width: 16),

                            //* kalori
                            Text(
                              '${activity.caloriesBurn} kal',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                            const SizedBox(width: 16),

                            //* mode
                            Text(
                              activity.mode?.name ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),

                  //* icon
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              ),
            ),

            //* divider
            if (!isLast)
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 1,
                color: Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }
}
