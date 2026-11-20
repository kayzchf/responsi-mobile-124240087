import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _usnameKey = 'user_username';

  static Future<void> login(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usnameKey, username);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usnameKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_usnameKey);
  }

  static Future<String?> getUsname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usnameKey);
  }

  /// [FUNGSI]: Alias/alternatif untuk `getEmail()` demi menjaga kompatibilitas kode lama.
  static Future<String?> getUsername() async {
    return getUsname();
  }
}
