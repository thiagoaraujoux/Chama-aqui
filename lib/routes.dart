import 'package:chamaaqui/views/admin.dart';
import 'package:chamaaqui/views/cadastro.dart';
import 'package:chamaaqui/views/home_page.dart';
import 'package:chamaaqui/views/login.dart';
import 'package:chamaaqui/views/perfil_usuario.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String home = '/';
  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String admin = '/admin';
  static const String perfil = '/perfil';

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => MyHomePage(title: '',));
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case cadastro:
        return MaterialPageRoute(builder: (_) => CadastroPage());
      case admin:
        return MaterialPageRoute(builder: (_) => AdminPage());
      case perfil:
        return MaterialPageRoute(builder: (_) => UserProfilePage());
      default:
        return MaterialPageRoute(builder: (_) => MyHomePage(title: '',));
    }
  }

  static String initialRoute = home;
}
