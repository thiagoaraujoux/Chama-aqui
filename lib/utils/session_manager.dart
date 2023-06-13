import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static late SharedPreferences _prefs;
  static const String _loggedInUserKey = 'loggedInUser';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void setLoggedInUser(String usuario) {
    _prefs.setString(_loggedInUserKey, usuario);
  }

  static String? getLoggedInUser() {
    return _prefs.getString(_loggedInUserKey);
  }

  static void clearLoggedInUser() {
    _prefs.remove(_loggedInUserKey);
  }
}
