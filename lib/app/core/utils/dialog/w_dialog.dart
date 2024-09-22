// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  static void showDialog(
    BuildContext context, {
    required String message,
    Widget? title,
    bool withAnimation = true,
    List<Widget> actions = const <Widget>[],
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionBuilder: (withAnimation)
          ? (c, a1, a2, child) {
              return ScaleTransition(
                scale: a1,
                child: child,
              );
            }
          : null,
      pageBuilder: (c, a1, a2) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: title,
            content: Text(message),
            actions: actions,
          );
        }
        return AlertDialog(
          elevation: 0,
          content: Text(message),
          title: title,
          shadowColor: Colors.transparent,
          actions: actions,
        );
      },
    );
  }
}
