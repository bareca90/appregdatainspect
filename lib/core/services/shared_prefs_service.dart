import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //Métodos para el Token
  static Future<void> saveToken(String token) async {
    await _prefs.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    return _prefs.getString('auth_token');
  }

  static Future<void> clearToken() async {
    await _prefs.remove('auth_token');
  }

  //Métodos para el usuario
  static Future<void> saveUsername(String username) async {
    await _prefs.setString('username', username);
  }

  static Future<String?> getUsername() async {
    return _prefs.getString('username');
  }

  static Future<void> clearUsername() async {
    await _prefs.remove('username');
  }
}
