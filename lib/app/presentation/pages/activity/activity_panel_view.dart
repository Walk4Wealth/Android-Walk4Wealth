import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/tracking_provider.dart';

class ActivityPanelView extends StatelessWidget {
  const ActivityPanelView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<TrackingProvider>(
          builder: (ctx, c, _) {
            return Column(
              children: [
                //* duration
                _duration(context, c),
                const SizedBox(height: 16),

                //* jarak tempuh // distance
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //* jarak tempuh in meters
                        _distanceInMeters(context, c),

                        //* jarak tempuh in kilometer
                        _distanceInKm(context, c),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                //* kecepatan // speed
                _speed(context, c),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _duration(BuildContext context, TrackingProvider c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'WAKTU',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          Text(
            c.stringTimer,
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontSize: 30),
          ),
        ],
      ),
    );
  }

  Widget _distanceInMeters(BuildContext context, TrackingProvider c) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'JARAK TEMPUH',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey.shade600),
          ),
          Text(
            NumberFormat('#,###').format(c.mileage.toInt()),
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'METER',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey.shade600),
          )
        ],
      ),
    );
  }

  Widget _distanceInKm(BuildContext context, TrackingProvider c) {
    final double distanceInKm = c.mileage / 1000;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            distanceInKm.toStringAsFixed(2),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
          ),
          const SizedBox(width: 16),
          Text(
            'KM',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _speed(BuildContext context, TrackingProvider c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'KECEPATAN',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey.shade600),
          ),
          Text(
            c.speed.toStringAsFixed(2),
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontSize: 30),
          ),
          Text(
            'KM/H',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey.shade600),
          )
        ],
      ),
    );
  }
}
