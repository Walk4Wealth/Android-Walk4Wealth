import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceSetup {
  DeviceSetup._();

  static void setup() {
    _setOrientation();
    setStatusBarStyle();
  }

  static void _setOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static void setStatusBarStyle() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));
  }
}
