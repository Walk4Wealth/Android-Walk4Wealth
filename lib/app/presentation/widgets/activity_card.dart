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

  void _navigateToActivityDetailPage(BuildContext context) {
    Navigator.pushNamed(
      context,
      To.ACTIVITY_DETAIL,
      arguments: activity,
    );
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius radius = isOne
        ? BorderRadius.circular(8)
        : BorderRadius.vertical(
            top: isFirst ? const Radius.circular(8) : Radius.zero,
            bottom: isLast ? const Radius.circular(8) : Radius.zero,
          );
    double mileageInKm = (activity.mileage ?? 0) / 1000;

    return Material(
      color: Colors.white,
      borderRadius: radius,
      //* navigasi ke halaman detail aktivitas
      child: InkWell(
        onTap: () => _navigateToActivityDetailPage(context),
        borderRadius: radius,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  //* foto aktivitas
                  _imageActivity(),
                  const SizedBox(width: 24),

                  //* data
                  Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //* tanggal aktivitas
                        _dateTime(context),
                        const SizedBox(height: 8),

                        //* jarak tempuh (meter)
                        _distanceImMeters(context),
                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //* jarak tempuh (kilometer)
                            _distanceInKm(mileageInKm, context),

                            //* kalori
                            _calories(context),

                            //* mode aktivitas
                            _activityMode(context),

                            //* poin yang didapatkan
                            _pointEarned(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),

                  //* icon forward
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

  Widget _imageActivity() {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.blue.shade50,
      child: Image.asset(
        (activity.activityId == 1) ? AssetImg.walking : AssetImg.running,
      ),
    );
  }

  Widget _dateTime(BuildContext context) {
    return Text(
      DateFormat('dd MMMM yyyy', 'id').format(
        DateTime.parse(activity.dateTime ?? '').toLocal(),
      ),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _distanceImMeters(BuildContext context) {
    return Text(
      '${NumberFormat('#,###').format(activity.mileage)} meter',
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _distanceInKm(double mileageInKm, BuildContext context) {
    return Text(
      '${mileageInKm.toStringAsFixed(1)} km',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _calories(BuildContext context) {
    return Text(
      '${activity.caloriesBurn} kal',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _activityMode(BuildContext context) {
    return Text(
      activity.mode?.name ?? '',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _pointEarned(BuildContext context) {
    return Text(
      '${activity.pointsEarned ?? 0} Poin',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
