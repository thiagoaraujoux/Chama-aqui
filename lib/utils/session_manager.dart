import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _loggedInUserKey = 'loggedInUser';

  static Future<bool> setLoggedInUser(String username) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_loggedInUserKey, username);
    } catch (e) {
      print('Erro ao salvar o usuário logado: $e');
      return false;
    }
  }

  static Future<String?> getLoggedInUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_loggedInUserKey);
    } catch (e) {
      print('Erro ao obter o usuário logado: $e');
      return null;
    }
  }

  static Future<bool> clearLoggedInUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_loggedInUserKey);
    } catch (e) {
      print('Erro ao limpar o usuário logado: $e');
      return false;
    }
  }
}
