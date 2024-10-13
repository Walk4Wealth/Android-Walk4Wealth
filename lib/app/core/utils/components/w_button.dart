// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum ButtonType { FILL, OUTLINED }

class WButton extends StatelessWidget {
  const WButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.child,
    this.icon,
    this.backgroundColor,
    this.expand = false,
    this.padding = 16.0,
    this.bold = true,
    this.borderRadius = 4.0,
    this.type = ButtonType.FILL,
    this.margin = EdgeInsets.zero,
  });

  final bool bold;
  final bool expand;
  final Widget? icon;
  final String label;
  final Widget? child;
  final double padding;
  final ButtonType? type;
  final double borderRadius;
  final Color? backgroundColor;
  final EdgeInsetsGeometry margin;
  final void Function()? onPressed;

  double? get _width {
    if (expand) {
      return double.infinity;
    }
    return null;
  }

  ButtonStyle get _style {
    return ElevatedButton.styleFrom(
        elevation: (type == ButtonType.OUTLINED) ? null : 0,
        backgroundColor: backgroundColor,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ));
  }

  Widget? get _child {
    if (child != null) {
      return child;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon ?? const SizedBox.shrink(),
        SizedBox(width: (icon != null) ? 8 : null),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: (bold) ? FontWeight.bold : null,
            color: (type == ButtonType.OUTLINED) ? Colors.blue : Colors.white,
          ),
        ),
      ],
    );
  }

  EdgeInsetsGeometry get _padding {
    return EdgeInsets.all(padding);
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonType.OUTLINED:
        return Padding(
          padding: margin,
          child: SizedBox(
            width: _width,
            child: OutlinedButton(
              style: _style,
              onPressed: onPressed,
              child: Padding(
                padding: _padding,
                child: _child,
              ),
            ),
          ),
        );
      default:
        return Padding(
          padding: margin,
          child: SizedBox(
            width: _width,
            child: ElevatedButton(
              style: _style,
              onPressed: onPressed,
              child: Padding(
                padding: _padding,
                child: _child,
              ),
            ),
          ),
        );
    }
  }
}
