import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/request_state.dart';
import '../../../core/routes/navigate.dart';
import '../../../core/utils/components/w_button.dart';
import '../../../core/utils/strings/asset_img_string.dart';
import '../../providers/activity_provider.dart';
import '../../widgets/activity_card.dart';

class HomeListActivity extends StatelessWidget {
  const HomeListActivity({
    super.key,
  });

  //* load data activity
  Future<void> _loadData(BuildContext context) async {
    await context.read<ActivityProvider>().getActivity();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8,
            left: 16,
            right: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Aktivitas Terakhir',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),

                  //* tombol semua aktivitas muncul ketika aktivitas > 5
                  Consumer<ActivityProvider>(
                    builder: (ctx, c, _) {
                      if (c.activities.length <= 5) {
                        return const SizedBox.shrink();
                      }
                      return TextButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, To.ALL_ACTIVITIES),
                        icon: const Icon(Icons.arrow_forward, size: 15),
                        iconAlignment: IconAlignment.end,
                        label: const Text(
                          'Semua aktivitas',
                          style: TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),

              //* list view state
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Consumer<ActivityProvider>(
                    builder: (ctx, c, _) {
                      if (c.getActivityState == RequestState.FAILURE) {
                        return _failureState(c);
                      }
                      if (c.getActivityState == RequestState.SUCCESS) {
                        if (c.activities.isEmpty) {
                          return _emptyActivity(context);
                        }
                        return _activityListView(context, c);
                      }
                      return _loadingState(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _activityListView(BuildContext context, ActivityProvider c) {
    return RefreshIndicator(
      onRefresh: () async => _loadData(context),
      child: ListView.builder(
        itemCount: c.activities.length.clamp(1, 5),
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final activity = c.activities[index];
          final isOne = (c.activities.length == 1);
          final isFirst = (index == 0);
          final isLast = (index == c.activities.length - 1);

          return ActivityCard(
            activity,
            isFirst: isFirst,
            isLast: isLast,
            isOne: isOne,
          );
        },
      ),
    );
  }

  Widget _failureState(ActivityProvider c) {
    return Center(
      child: Text(
        c.errorMessage!,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _emptyActivity(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          height: 200,
          child: Image.asset(AssetImg.noActivity),
        ),
        const SizedBox(height: 16),
        const Text('Kamu belum melakukan aktivitas apapun'),
        const SizedBox(height: 16),
        WButton(
          padding: 12,
          label: 'Mulai Sekarang',
          type: ButtonType.OUTLINED,
          onPressed: () => Navigator.pushNamed(context, To.ACTIVITY),
        ),
      ],
    );
  }

  Widget _loadingState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator.adaptive(),
        const SizedBox(height: 16),
        Text('Memuat...', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
