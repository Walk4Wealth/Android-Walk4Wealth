// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../dialog/w_dialog.dart';

enum MaterialDialogActionType { OUTLINED, FILLED }

class MaterialModalDialog extends StatelessWidget {
  const MaterialModalDialog({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.actions = const <DialogAction>[],
  });

  final String? title;
  final String message;
  final Widget? icon;
  final List<DialogAction> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: icon,
      actionsPadding: EdgeInsets.zero,
      content: Text(message, textAlign: TextAlign.center),
      insetPadding: const EdgeInsets.symmetric(horizontal: 60),
      title: title != null ? Text(title!, textAlign: TextAlign.center) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titleTextStyle: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.w600),
      contentTextStyle: Theme.of(context).textTheme.bodySmall,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _buildAction(),
        ),
      ],
    );
  }

  List<Widget> _buildAction() {
    List<Widget> actionWidgets = [];

    for (var i = 0; i < actions.length; i++) {
      final isFirst = (i == 0);
      final isLast = (i == actions.length - 1);

      BorderRadius borderRadius = (actions.length == 1)
          ? const BorderRadius.vertical(bottom: Radius.circular(8))
          : BorderRadius.only(
              bottomLeft: isFirst ? const Radius.circular(8) : Radius.zero,
              bottomRight: isLast ? const Radius.circular(8) : Radius.zero,
            );

      actionWidgets.add(MaterialDialogAction(
        label: actions[i].label,
        color: actions[i].color,
        onPressed: actions[i].onPressed,
        type: actions[i].isDefaultAction
            ? MaterialDialogActionType.FILLED
            : MaterialDialogActionType.OUTLINED,
        borderRadius: borderRadius,
      ));
    }

    return actionWidgets;
  }
}

class MaterialDialogAction extends StatelessWidget {
  const MaterialDialogAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.borderRadius = BorderRadius.zero,
    this.type = MaterialDialogActionType.FILLED,
  });

  final MaterialDialogActionType type;
  final String label;
  final void Function() onPressed;
  final BorderRadius borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case MaterialDialogActionType.FILLED:
        return _filledButton();
      case MaterialDialogActionType.OUTLINED:
        return _outlineButton();
    }
  }

  Widget _filledButton() {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: color,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Text(label),
        ),
      ),
    );
  }

  Widget _outlineButton() {
    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Text(label),
        ),
      ),
    );
  }
}
