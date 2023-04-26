import 'package:chamaaqui/views/cadastro.dart';
import 'package:chamaaqui/views/home_page.dart';
import 'package:chamaaqui/views/login.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String home = '/';
  static const String login = '/login';
  static const String cadastro = '/cadastro';

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => MyHomePage(title: '',));
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case cadastro:
        return MaterialPageRoute(builder: (_) => CadastroPage());
      default:
        return MaterialPageRoute(builder: (_) => MyHomePage(title: '',));
    }
  }

  static String initialRoute = home;
}
