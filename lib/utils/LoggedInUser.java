import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Classe do usuário logado
class LoggedInUser {
  final String nome;
  final String servico;
  final List<String> portfolio;
  final List<String> avaliacoes;

  LoggedInUser({
    required this.nome,
    required this.servico,
    required this.portfolio,
    required this.avaliacoes,
  });
}

// Classe para gerenciar o estado do usuário logado usando o Provider
class LoggedInUserManager extends ChangeNotifier {
  LoggedInUser? _user;

  void setUser(LoggedInUser user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  LoggedInUser? get user => _user;
}

class PerfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<LoggedInUserManager>(context).user;

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
              if (loggedInUser != null)
                Column(
                  children: [
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
                      loggedInUser.nome,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      loggedInUser.servico,
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
                              children: loggedInUser.portfolio
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
                              children: loggedInUser.avaliacoes
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
              if (loggedInUser == null)
                Text(
                  'Nenhum usuário logado.',
                  style: TextStyle(fontSize: 18),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
