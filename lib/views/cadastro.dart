import 'package:flutter/material.dart';

import '../database_helper.dart';
import '../models/usuario.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  late DatabaseHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    final nome = nomeController.text;
    final email = emailController.text;
    final senha = senhaController.text;

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Confirmação de cadastro'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: $nome'),
            Text('E-mail: $email'),
            Text('Senha: $senha'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              dbHelper.createUser(Usuario(nome: nome, email: email, senha: senha));
              Navigator.of(context).pop();
              _exibirMensagemSucesso();
            },
            child: Text('Confirmar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _exibirMensagemSucesso() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Cadastro efetuado com sucesso!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new),
    onPressed: () => Navigator.of(context).pop(),
    color: Colors.blue.withOpacity(0.5), // cor do botão de voltar
    ),
    ),
    body: SingleChildScrollView( // adicionando scroll view
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    SizedBox(height: 32),
    Text(
              'Cadastro',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Preencha os campos abaixo:',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 32),
            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _cadastrar,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    'Cadastrar',
                    style: TextStyle(fontSize: 18),
                  ),
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
