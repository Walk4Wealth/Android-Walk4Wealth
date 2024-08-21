import 'package:flutter/material.dart';

import '../falvor/flavor_config.dart';

Future<Widget> initializeApp(FlavorConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  return App(config);
}

class App extends StatelessWidget {
  const App(this.config, {super.key});

  final FlavorConfig config;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(config.appName),
        ),
      ),
    );
  }
}
