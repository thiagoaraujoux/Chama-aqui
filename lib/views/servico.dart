import 'package:chamaaqui/views/perfil.dart';
import 'package:flutter/material.dart';

import '../models/servico.dart';


class Servico extends StatefulWidget {
  final String imagePath;
  final String imageText;

  const Servico({Key? key, required this.imagePath, required this.imageText})
      : super(key: key);

  @override
  _ServicoState createState() => _ServicoState();
}

class _ServicoState extends State<Servico> {
  int _selectedIndex = 0;

  List<String> getCategoriasServico(String servico) {
    for (var i = 0; i < servicos.length; i++) {
      if (servicos[i].servico == servico) {
        return servicos[i].categorias;
      }
    }
    return [];
  }

  List<List<String>> _usuarios = [
    ['João da Silva', 'Pedreiro', 'Item 1', 'Item 2', 'Recomendação 1', 'Recomendação 2'],
    ['Maria Santos', 'Eletricista', 'Item 3', 'Item 4', 'Recomendação 3', 'Recomendação 4'],
    ['José Oliveira', 'Encanador', 'Item 5', 'Item 6', 'Recomendação 5', 'Recomendação 6'],
  ];

  @override
  Widget build(BuildContext context) {
    List<String> categorias = getCategoriasServico(widget.imageText);

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(widget.imagePath),
                  ),
                ),
              ),
              Container(
                height: 200,
                color: Colors.black.withOpacity(0.5),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.imageText,
                    style: TextStyle(
                      fontFamily: 'Playlist',
                      fontSize: 60,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: _selectedIndex == index ? Colors.blue : Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedIndex == index ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        categorias[index],
                        style: TextStyle(
                          color: _selectedIndex == index ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: _usuarios.length,
              itemBuilder: (context, index) {
                if (_usuarios[index][1] == categorias[_selectedIndex]) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PerfilPage(
                            nome: _usuarios[index][0],
                            servico: _usuarios[index][1],
                            portfolio: [_usuarios[index][2], _usuarios[index][3]],
                            avaliacoes: [_usuarios[index][4], _usuarios[index][5]],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/profile_image.png'),
                            radius: 30,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _usuarios[index][0],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  _usuarios[index][1],
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(); // Retorna um container vazio se não for a especialidade selecionada
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
