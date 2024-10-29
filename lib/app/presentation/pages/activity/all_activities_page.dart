import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/enums/request_state.dart';
import '../../../core/utils/components/to_top_button.dart';
import '../../../core/utils/components/w_app_bar.dart';
import '../../../core/utils/components/w_button.dart';
import '../../providers/activity_provider.dart';
import '../../widgets/activity_card.dart';

class AllActivitiesPage extends StatefulWidget {
  const AllActivitiesPage({super.key});

  @override
  State<AllActivitiesPage> createState() => _AllActivitiesPageState();
}

class _AllActivitiesPageState extends State<AllActivitiesPage> {
  final _scrollController = ScrollController();
  bool _showToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  //* load data
  void _loadData() async {
    await context.read<ActivityProvider>().getActivity();
  }

  //* scroll listener
  void _scrollListener() {
    if (_scrollController.offset >= 300) {
      setState(() => _showToTop = true);
    } else {
      setState(() => _showToTop = false);
    }
  }

  //* to top
  void _toTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WAppBar(title: 'Semua aktivitas'),
      body: Consumer<ActivityProvider>(builder: (ctx, c, _) {
        if (c.getActivityState == RequestState.FAILURE) {
          return _failureState(c.errorMessage!);
        }
        if (c.getActivityState == RequestState.SUCCESS) {
          return _activitiesListView(context, c);
        }
        return _loadingState();
      }),
      floatingActionButton: _showToTop ? ToTopButton(_toTop) : null,
    );
  }

  Widget _activitiesListView(BuildContext context, ActivityProvider c) {
    return RefreshIndicator(
      onRefresh: () async => _loadData(),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: c.activities.length,
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final activity = c.activities[index];
          final isFirst = (index == 0);
          final isOne = (c.activities.length == 1);
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

  Widget _failureState(String message) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            WButton(
              padding: 12,
              label: 'Coba lagi',
              type: ButtonType.OUTLINED,
              onPressed: _loadData,
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadingState() {
    Color baseColor = Colors.grey.shade300;
    Color highlightColor = Colors.grey.shade100;

    return ListView.separated(
      itemCount: 5,
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      separatorBuilder: (c, i) => const SizedBox(height: 38),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Row(
          children: [
            //* ilustration
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: baseColor,
                ),
              ),
            ),
            const SizedBox(width: 16),

            //* activity data
            Flexible(
              fit: FlexFit.tight,
              child: LayoutBuilder(builder: (_, size) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      child: Container(
                        width: size.maxWidth * 0.3,
                        height: 10,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Shimmer.fromColors(
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      child: Container(
                        width: size.maxWidth * 0.4,
                        height: 15,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Shimmer.fromColors(
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      child: Container(
                        width: size.maxWidth * 0.6,
                        height: 10,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),

            //* icon forward
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Icon(
                Icons.arrow_forward_ios,
                color: baseColor,
              ),
            ),
          ],
        );
      },
    );
  }
}
