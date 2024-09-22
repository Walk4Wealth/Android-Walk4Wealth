import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ToTopButton extends StatelessWidget {
  const ToTopButton(
    this.onTap, {
    super.key,
    this.radius = 18,
    this.bottomPadding = 0.0,
  });

  final void Function() onTap;
  final double radius;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: bottomPadding,
      ),
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: FittedBox(
          child: FloatingActionButton.small(
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: onTap,
            highlightElevation: 0,
            child: Icon(
              Iconsax.arrow_up_3,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
