import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  final String nome;
  final String servico;
  final List<String> portfolio;
  final List<String> avaliacoes;

  PerfilPage({
    required this.nome,
    required this.servico,
    required this.portfolio,
    required this.avaliacoes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/images/avatar.png'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.yellow, size: 24),
                  Icon(Icons.star, color: Colors.yellow, size: 24),
                  Icon(Icons.star, color: Colors.yellow, size: 24),
                  Icon(Icons.star_half, color: Colors.yellow, size: 24),
                  Icon(Icons.star_outline, color: Colors.yellow, size: 24),
                ],
              ),
              SizedBox(height: 20),
              Text(
                nome,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                servico,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Lógica para abrir a tela de chat
                    },
                    icon: Icon(Icons.chat),
                    label: Text('Chat'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Lógica para favoritar o perfil
                    },
                    icon: Icon(Icons.favorite),
                    label: Text('Favoritar'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.folder, size: 24),
                          SizedBox(width: 10),
                          Text(
                            'Portfólio',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: portfolio
                            .map((item) => ListTile(
                          leading: Icon(Icons.image),
                          title: Text(item),
                        ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, size: 24),
                          SizedBox(width: 10),
                          Text(
                            'Avaliações',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: avaliacoes
                            .map((item) => ListTile(
                          leading: Icon(Icons.comment),
                          title: Text(item),
                        ))
                            .toList(),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Deixe seu comentário',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Adicionar lógica para enviar o comentário
                            },
                            child: Text('Enviar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

