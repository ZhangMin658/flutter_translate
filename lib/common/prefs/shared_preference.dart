import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  static const String THEME_SELECTED_PREFS_KEY = "THEME_SELECTED_PREFS_KEY";
  static const String SCAN_LANG_PREFS_KEY = "SCAN_LANG_PREFS_KEY";
  static const String TRANSLATE_LANG_PREFS_KEY = "TRANSLATE_LANG_PREFS_KEY";
  static const String SHOW_INTRO_PAGE_PREFS_KEY = "SHOW_INTRO_PAGE_PREFS_KEY";
  static const String NUM_SCAN_PREFS_KEY = "NUM_SCAN_PREFS_KEY";

  // ----------------------------------------------------------
  /// Method that read/saves bool
  /// ----------------------------------------------------------
  static Future<bool> saveBool(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  static Future<bool> getBool(String key, {bool defaultValue: false}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  // ----------------------------------------------------------
  /// Method that read/saves int
  /// ----------------------------------------------------------
  static Future<bool> saveInt(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(key, value);
  }

  static Future<int> getInt(String key, {defaultValue: 0}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? defaultValue;
  }

  // ----------------------------------------------------------
  /// Method that read/saves double
  /// ----------------------------------------------------------
  static Future<bool> saveDouble(String key, double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(key, value);
  }

  static Future<double> getDouble(String key, {defaultValue: 0}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? defaultValue;
  }

  // ----------------------------------------------------------
  /// Method that read/saves double
  /// ----------------------------------------------------------
  static Future<bool> saveString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<String> getString(String key,
      {String defalutValue = ""}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? defalutValue;
  }

  // ----------------------------------------------------------
  /// Method that clear all
  /// ----------------------------------------------------------
  static Future<bool> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
