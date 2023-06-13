import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/session_manager.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    loadUsuarios();
  }

  Future<void> loadUsuarios() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool realizarLogin() {
    final email = _emailController.text;
    final senha = _senhaController.text;

    if (email == 'thiago@' && senha == '123') {
      Navigator.of(context).pushReplacementNamed('/admin');
    }

    String? usuariosJson = _prefs.getString('usuarios');
    if (usuariosJson != null) {
      List<dynamic> usuarios = json.decode(usuariosJson);
      for (var usuario in usuarios) {
        if (usuario['email'] == email && usuario['senha'] == senha) {
          SessionManager.setLoggedInUser(usuario['nome']);
          return true; // Login bem-sucedido
        }
      }
    }

    return false; // Login falhou
  }

  void fazerLogin() {
    if (_formKey.currentState!.validate()) {
      if (realizarLogin()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login realizado com sucesso!')),
        );
        Navigator.of(context).pushReplacementNamed('/home'); // Redirecionar para a página inicial
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário ou senha inválidos!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.blue, // Alterado para a cor azul
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Text(
                'Login',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Entre com suas informações de login',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira o e-mail.';
                        } else if (!value.contains('@')) {
                          return 'E-mail inválido.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _senhaController,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira a senha.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: fazerLogin,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text(
                            'Entrar',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/cadastro');
                        },
                        child: Text(
                          'Ainda não possui uma conta? Clique aqui para se cadastrar.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
