import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Localization {
  Localization._();

  static const locale = Locale('id', 'ID');
  static const supportedLocales = [
    Locale('id', 'ID'),
    Locale('id', 'US'),
  ];
  static const delegates = [
    GlobalCupertinoLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}
