import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.bottom,
    this.titleWidget,
    this.centerTitle = true,
  });

  final String? title;
  final Widget? leading;
  final bool centerTitle;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: (title != null) ? Text(title!) : titleWidget,
      elevation: 0,
      centerTitle: centerTitle,
      bottom: bottom ?? const _AppBarLine(),
      actions: actions,
      leading: leading,
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: Theme.of(context).primaryColor,
      ),
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Size get preferredSize {
    final double bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }
}

class _AppBarLine extends StatelessWidget implements PreferredSizeWidget {
  // ignore: unused_element
  const _AppBarLine({super.key, this.height = 1});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      color: Colors.grey,
      height: height.toDouble(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height.toDouble());
}
