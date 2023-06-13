
import 'package:flutter/material.dart';
import 'routes.dart';
import 'utils/session_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionManager.init(); // Chamar o método init() antes de executar o MyApp()
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chama aqui',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: Routes.generateRoutes,
      initialRoute: Routes.initialRoute,
    );
  }
}