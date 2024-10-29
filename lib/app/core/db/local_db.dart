// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class Db {
  static Db? _instance;

  Db._internal() {
    _instance = this;
  }

  factory Db() => _instance ?? Db._internal();

  SharedPreferences? _preferences;

  Future<SharedPreferences> init() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!;
  }

  final TOKEN_KEY = '_token_key_';
  final USER_KEY = '_user_key_';
  final IS_SHOW_TRACKING_ALERT_DIALOG_KEY = '_is_show_alert_dialog_key_';

  Future<void> set(String key, String value) async {
    try {
      await _preferences?.setString(key, value);
    } catch (e) {
      rethrow;
    }
  }

  String? get(String key) {
    try {
      final value = _preferences?.getString(key);
      return value;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String key) async {
    try {
      await _preferences?.remove(key);
    } catch (e) {
      rethrow;
    }
  }

  bool hasData(String key) {
    try {
      return _preferences?.containsKey(key) ?? false;
    } catch (e) {
      rethrow;
    }
  }
}
