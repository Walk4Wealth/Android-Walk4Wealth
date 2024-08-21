import 'package:flutter/material.dart';

import 'app/app.dart';
import 'falvor/flavor_type.dart';
import 'falvor/flavor_config.dart';

Future<void> main() async {
  final config = FlavorConfig(appName: 'W4W DEV', type: FlavorType.DEV);
  final app = await initializeApp(config);

  runApp(app);
}
