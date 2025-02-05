import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../transaction/history_view.dart';
import 'poin_shop_view.dart';
import '../../providers/user_provider.dart';
import '../../../core/utils/components/w_app_bar.dart';
import '../../../core/utils/components/w_tab_bar.dart';

class PointPage extends StatelessWidget {
  const PointPage({super.key});

  @override
  Widget build(BuildContext context) {
    final point = context.watch<UserProvider>().user?.totalPoints ?? 0;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: WAppBar(
          title: 'Point Kamu $point',
          bottom: const WTabBar([
            Tab(text: 'Tukar Poin'),
            Tab(text: 'Reward Kamu'),
          ]),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            PoinShopView(),
            HistoryView(),
          ],
        ),
      ),
    );
  }
}
