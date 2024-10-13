// ignore_for_file: constant_identifier_names

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../../enums/tracking_state.dart';
import '../components/material_modal_dialog.dart';

enum SnackBarType { ERROR, WARNING, NORMAL }

class WDialog {
  WDialog._();

  static BuildContext? _dialogContext;

  static void snackbar(
    BuildContext context, {
    required String message,
    int seconds = 4,
    SnackBarType type = SnackBarType.NORMAL,
  }) {
    Color? getColor() {
      switch (type) {
        case SnackBarType.ERROR:
          return Colors.red;
        case SnackBarType.WARNING:
          return Colors.amber;
        default:
          return Colors.blue;
      }
    }

    Icon? getIcon() {
      const color = Colors.grey;
      switch (type) {
        case SnackBarType.ERROR:
          return const Icon(Icons.error_outline, color: color);
        case SnackBarType.WARNING:
          return const Icon(Icons.warning_amber_rounded, color: color);
        default:
          return null;
      }
    }

    Flushbar(
      messageSize: 12,
      message: message,
      shouldIconPulse: false,
      leftBarIndicatorColor: getColor(),
      duration: Duration(seconds: seconds),
      borderRadius: BorderRadius.circular(4),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      icon: getIcon(),
    ).show(context);
  }

  static void activitySnackbar(
    BuildContext context,
    String message,
    TrackingState state,
  ) {
    bool isPause = (state == TrackingState.PAUSE);
    final bgColor = isPause ? Colors.amber : Colors.green;
    final textColor = isPause ? Colors.black : Colors.white;
    Flushbar(
      messageText: Text(
        message.toUpperCase(),
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: textColor, fontWeight: FontWeight.w600),
      ),
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 500),
      backgroundColor: bgColor,
    ).show(context);
  }

  static void showLoading(
    BuildContext context, {
    String message = 'Memuat ...',
  }) async {
    if (_dialogContext != null) return;

    _dialogContext = context;
    await showGeneralDialog(
        context: context,
        pageBuilder: (c, a1, a2) {
          return Dialog(
            backgroundColor: Colors.grey.shade900,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 24),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
        transitionBuilder: (ctx, a1, a2, chld) {
          return ScaleTransition(scale: a1, child: chld);
        });
    _dialogContext = null;
  }

  static void closeLoading() {
    if (_dialogContext != null) {
      Navigator.of(_dialogContext!).pop();
      _dialogContext = null;
    }
  }

  static Future<T?> showDialog<T extends Object?>(
    BuildContext context, {
    required String message,
    String? title,
    Widget? icon,
    bool dismissible = true,
    bool canPop = true,
    List<DialogAction> actions = const <DialogAction>[],
  }) async {
    return await showGeneralDialog(
      context: context,
      barrierDismissible: dismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionBuilder: (_, a1, __, child) =>
          ScaleTransition(scale: a1, child: child),
      pageBuilder: (c, a1, a2) => PopScope(
        canPop: canPop,
        child: MaterialModalDialog(
          title: title,
          icon: icon,
          message: message,
          actions: actions,
        ),
      ),
    );
  }
}

class DialogAction extends StatelessWidget {
  const DialogAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.isDefaultAction = false,
  });

  final String label;
  final void Function() onPressed;
  final bool isDefaultAction;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return MaterialDialogAction(
      label: label,
      color: color,
      type: isDefaultAction
          ? MaterialDialogActionType.FILLED
          : MaterialDialogActionType.OUTLINED,
      onPressed: onPressed,
    );
  }
}
