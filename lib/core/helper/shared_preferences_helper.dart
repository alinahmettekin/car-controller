import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferencesHelper? _instance;

  static SharedPreferencesHelper get prefs {
    return _instance ??= SharedPreferencesHelper._internal();
  }

  static SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferencesHelper._internal() {
    init();
  }

  static saveButtonOption(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static String getString(String key, {String defaultValue = ''}) {
    return _prefs!.getString(key) ?? defaultValue;
  }

  static Future<bool> setString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }
}
