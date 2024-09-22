import 'package:flutter/material.dart';

class WTabBar extends StatelessWidget implements PreferredSizeWidget {
  const WTabBar(this.tabs, {super.key});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: tabs,
      indicatorWeight: 2.5,
      indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
      indicatorColor: Theme.of(context).primaryColor,
      labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
      unselectedLabelStyle: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(color: Colors.black45),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(46.0);
  }
}
