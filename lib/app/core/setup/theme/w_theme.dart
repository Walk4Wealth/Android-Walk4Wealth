import 'package:flutter/material.dart';

class WTheme {
  WTheme._();

  static const themeMode = ThemeMode.light;
  static final theme = ThemeData(
    useMaterial3: false,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.grey.shade100,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.fromSwatch(),
  );
}
