import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/components/capture_map.dart';
import '../../../core/utils/components/w_app_bar.dart';
import '../../../core/utils/components/w_button.dart';
import '../../../core/utils/dialog/w_dialog.dart';
import '../../providers/activity_provider.dart';
import '../../providers/tracking_provider.dart';

class ActivitySavePage extends StatelessWidget {
  const ActivitySavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _PopScopeWrapper(
      child: Scaffold(
        appBar: const WAppBar(title: 'Simpan Aktivitas'),
        body: SingleChildScrollView(
          child: Consumer<TrackingProvider>(
            builder: (ctx, c, _) {
              final mileageInKm = c.mileage / 1000;
              return Column(
                children: [
                  //* capture map
                  SizedBox(
                    width: double.infinity,
                    height: 180,
                    child: CaptureMap(points: c.coordinates),
                  ),

                  //* data aktivitas
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
                          const SizedBox(height: 8),

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
                                    DateFormat('EEEE, dd MMMM yyyy', 'id')
                                        .format(c.currentDate),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                //* durasi
                                _buildData(
                                  context,
                                  title: 'Durasi',
                                  data: Text(
                                    c.stringDuration,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                //* langkah
                                _buildData(
                                  context,
                                  title: 'Langkah',
                                  data: Text(
                                    '${NumberFormat('#,###').format(c.step)} langkah',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      Text(
                                        '${NumberFormat('#,###').format(c.mileage)} m',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 200),
                ],
              );
            },
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: WButton(
            padding: 12,
            label: 'Simpan',
            onPressed: () async {
              final trackingC = context.read<TrackingProvider>();

              await context.read<ActivityProvider>().createActivity(
                    context,
                    activityId: trackingC.getActivityId(),
                    duration: trackingC.duration.inSeconds,
                    mileage: trackingC.mileage.toInt(),
                    steps: trackingC.step,
                    coordinates: trackingC.coordinates,
                  );
            },
          ),
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

//* pop scope wrapper
class _PopScopeWrapper extends StatelessWidget {
  const _PopScopeWrapper({required this.child});

  final Widget child;

  Future<bool?> _showBackDialog(BuildContext context) async {
    return WDialog.showDialog<bool>(
      context,
      icon: const Icon(Iconsax.trash),
      title: 'Hapus Aktivitas',
      message:
          'Apakah kamu yakin ingin meninggalkan halaman ini dan menghapus aktivitas yang telah dikalukan?',
      actions: [
        DialogAction(
          label: 'Batal',
          onPressed: () => Navigator.pop(context, false),
        ),
        DialogAction(
          label: 'Hapus',
          isDefaultAction: true,
          onPressed: () {
            context.read<TrackingProvider>().resetTrackingData();
            Navigator.pop(context, true);
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        final shouldPop = await _showBackDialog(context) ?? false;
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: child,
    );
  }
}
