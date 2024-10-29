import 'package:flutter/services.dart';

class DeviceSetup {
  DeviceSetup._();

  static void setup() {
    _setOrientation();
  }

  static void _setOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
