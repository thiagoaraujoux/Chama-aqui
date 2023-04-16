import 'package:chamaaqui/views/servico.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

  static const String routeName = '/';
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> images = [
    {
      'path': 'assets/images/reforma.png',
      'text': 'Reforma',
    },
    {
      'path': 'assets/images/limpeza.png',
      'text': 'Limpeza',
    },
    {
      'path': 'assets/images/informatica.jpg',
      'text': 'Informática',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'Chama',
            style: TextStyle(fontSize: 30, fontFamily: 'Fredoka One'),
            textAlign: TextAlign.center,
          ),
          Text(
            'aqui',
            style: TextStyle(fontSize: 30, fontFamily: 'Fredoka One'),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 250),
                        pageBuilder: (_, __, ___) => Servico(
                          imagePath: images[index]['path'],
                          imageText: images[index]['text'],
                        ),
                        transitionsBuilder: (_, animation, __, child) {
                          return ScaleTransition(
                            scale: Tween<double>(begin: 0.0, end: 1.0)
                                .animate(animation),
                            child: Hero(
                              tag: 'image_$index',
                              child: child,
                            ),
                          );
                        },
                      ),
                    );
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
                          image: AssetImage(images[index]['path']),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Center(
                          child: Hero(
                            tag: 'image_$index',
                            child: Text(
                              images[index]['text'],
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
          ),
        ],
      ),
    );
  }
}
