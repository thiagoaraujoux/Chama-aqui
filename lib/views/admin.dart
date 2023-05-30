import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  List<dynamic> _usuarios = [];

  @override
  void initState() {
    super.initState();
    carregarUsuarios();
  }

  Future<void> carregarUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final usuariosJson = prefs.getString('usuarios');
    if (usuariosJson != null) {
      setState(() {
        _usuarios = json.decode(usuariosJson);
      });
    }
  }

  void cadastrarUsuario() {
    if (_formKey.currentState!.validate()) {
      final novoUsuario = {
        'nome': _nomeController.text,
        'email': _emailController.text,
        'senha': _senhaController.text,
      };

      setState(() {
        _usuarios.add(novoUsuario);
      });

      _nomeController.clear();
      _emailController.clear();
      _senhaController.clear();

      // Salvar usuários no SharedPreferences
      salvarUsuarios();
    }
  }

  void editarUsuario(dynamic usuario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final editarNomeController = TextEditingController(text: usuario['nome']);
        final editarEmailController = TextEditingController(text: usuario['email']);
        final editarSenhaController = TextEditingController(text: usuario['senha']);

        return AlertDialog(
          title: Text('Editar Usuário'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: editarNomeController,
                  decoration: InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o nome.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: editarEmailController,
                  decoration: InputDecoration(labelText: 'E-mail'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o e-mail.';
                    } else if (!value.contains('@')) {
                      return 'E-mail inválido.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: editarSenhaController,
                  decoration: InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira a senha.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    usuario['nome'] = editarNomeController.text;
                    usuario['email'] = editarEmailController.text;
                    usuario['senha'] = editarSenhaController.text;
                  });

                  Navigator.of(context).pop();

                  // Salvar usuários no SharedPreferences
                  salvarUsuarios();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void excluirUsuario(dynamic usuario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Tem certeza de que deseja excluir o usuário?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () {
                setState(() {
                  _usuarios.remove(usuario);
                });

                Navigator.of(context).pop();

                // Salvar usuários no SharedPreferences
                salvarUsuarios();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> salvarUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final usuariosJson = json.encode(_usuarios);
    await prefs.setString('usuarios', usuariosJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Início'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/home');
                // Lógica para ir para a tela inicial
              },
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () {
                // Lógica para sair da tela de admin
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, insira o nome.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
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
                    onPressed: cadastrarUsuario,
                    child: Text('Cadastrar'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _usuarios.length,
              itemBuilder: (context, index) {
                final usuario = _usuarios[index];
                return ListTile(
                  title: Text(usuario['nome']),
                  subtitle: Text(usuario['email']),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => editarUsuario(usuario),
                  ),
                  onLongPress: () => excluirUsuario(usuario),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
