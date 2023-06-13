import 'package:flutter/material.dart';
import '../routes.dart';
import '../utils/session_manager.dart';
import 'servico.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

  static const String routeName = '/';
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> images = [
    {'path': 'assets/images/reforma.png', 'text': 'Reforma'},
    {'path': 'assets/images/limpeza.png', 'text': 'Limpeza'},
    {'path': 'assets/images/informatica.jpg', 'text': 'Informática'},
  ];

  bool isDarkMode = false;
  bool isMenuOpen = false;
  String? loggedInUser;

  @override
  void initState() {
    super.initState();
    loadLoggedInUser();
  }

  Future<void> loadLoggedInUser() async {
    loggedInUser = await SessionManager.getLoggedInUser();
    setState(() {});
  }

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  void openServicePage(String imagePath, String imageText) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 250),
        pageBuilder: (_, __, ___) => Servico(
          imagePath: imagePath,
          imageText: imageText,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
            child: Hero(
              tag: 'image_$imageText',
              child: child,
            ),
          );
        },
      ),
    );
  }

  void navigateToLogin() {
    SessionManager.clearLoggedInUser(); // Limpar usuário logado
    Navigator.pushNamed(context, Routes.login);
  }

  void navigateToHome() {
    // Reset any user-related data
    // e.g., clear form fields, reset state variables, etc.
    Navigator.pop(context);
  }

  void navigateToUserProfile() {
    Navigator.pushNamed(context, Routes.perfil);
  }

  @override
  Widget build(BuildContext context) {
    final theme = isDarkMode ? ThemeData.dark() : ThemeData.light();

    return MaterialApp(
      title: widget.title,
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                'Chama',
                style: TextStyle(fontSize: 30, fontFamily: 'Fredoka One'),
              ),
              Text(
                ' aqui',
                style: TextStyle(fontSize: 30, fontFamily: 'Fredoka One'),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: navigateToLogin,
            ),
            IconButton(
              icon: Icon(Icons.lightbulb),
              onPressed: toggleDarkMode,
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40, // Increase avatar size
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      loggedInUser ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Perfil'),
                onTap: navigateToUserProfile,
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configurações'),
                onTap: () {
                  // Navigate to settings page
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sair'),
                onTap: () {
                  toggleMenu();
                  navigateToLogin();
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView( // Wrap with SingleChildScrollView
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true, // Set shrinkWrap to true
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final imagePath = images[index]['path'];
                  final imageText = images[index]['text'];

                  return GestureDetector(
                    onTap: () {
                      openServicePage(imagePath, imageText);
                    },
                    child: Card(
                      elevation: 6,
                      margin:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(imagePath),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Center(
                            child: Hero(
                              tag: 'image_$imageText',
                              child: Text(
                                imageText,
                                style: TextStyle(
                                  fontFamily: 'Playlist',
                                  color: Colors.white,
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
