import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _preferences;

  static const _keyUsername = 'theKey';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setStatoDelVar(String username) async =>
      await _preferences?.setString(_keyUsername, username);

  static String? getStatoDelVar() => _preferences?.getString(_keyUsername);

  
}
