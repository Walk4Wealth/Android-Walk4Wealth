import 'package:flutter/services.dart';

class DeviceSetup {
  DeviceSetup._();

  static void setup() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
