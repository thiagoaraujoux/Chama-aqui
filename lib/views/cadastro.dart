import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _servicoController = TextEditingController();

  List<Map<String, String>> usuarios = [];
  List<String> servicosSelecionados = [];

  late SharedPreferences _prefs;

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    loadUsuarios();
  }

  Future<void> loadUsuarios() async {
    _prefs = await SharedPreferences.getInstance();
    String? usuariosJson = _prefs.getString('usuarios');
    if (usuariosJson != null) {
      setState(() {
        usuarios = List<Map<String, String>>.from(
          (json.decode(usuariosJson) as List<dynamic>).map(
                (item) => Map<String, String>.from(item),
          ),
        );
      });
    }
  }

  Future<void> saveUsuarios() async {
    await _prefs.setString('usuarios', json.encode(usuarios));
  }

  void cadastrarUsuario() {
    if (_formKey.currentState!.validate()) {
      final nome = _nomeController.text;
      final email = _emailController.text;
      final senha = _senhaController.text;

      setState(() {
        usuarios.add({
          'nome': nome,
          'email': email,
          'senha': senha,
          'servico': servicosSelecionados.join(','),
        });
        _nomeController.clear();
        _emailController.clear();
        _senhaController.clear();
        _servicoController.clear();
        servicosSelecionados.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário cadastrado com sucesso!')),
      );

      saveUsuarios(); // Salva a lista de usuários
    }
  }

  void editarUsuario(int index) {
    String nome = usuarios[index]['nome']!;
    String email = usuarios[index]['email']!;
    String senha = usuarios[index]['senha']!;
    String servico = usuarios[index]['servico']!;
    servicosSelecionados = servico.split(',');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Editar Usuário'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: TextEditingController(text: nome),
                      onChanged: (value) {
                        nome = value;
                      },
                      decoration: InputDecoration(labelText: 'Nome'),
                    ),
                    TextFormField(
                      controller: TextEditingController(text: email),
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(labelText: 'E-mail'),
                    ),
                    TextFormField(
                      controller: TextEditingController(text: senha),
                      onChanged: (value) {
                        senha = value;
                      },
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Serviço',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      children: [
                        _buildServicoCheckbox(
                            'Informática', servicosSelecionados, setState),
                        _buildServicoCheckbox(
                            'Construção', servicosSelecionados, setState),
                        _buildServicoCheckbox(
                            'Limpeza', servicosSelecionados, setState),
                        // Adicione mais opções de serviços aqui
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      usuarios[index]['nome'] = nome;
                      usuarios[index]['email'] = email;
                      usuarios[index]['senha'] = senha;
                      usuarios[index]['servico'] = servicosSelecionados.join(',');
                    });
                    saveUsuarios(); // Salva a lista de usuários
                    Navigator.of(context).pop();
                  },
                  child: Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildServicoCheckbox(
      String label, List<String> selectedServices, Function setState) {
    final isSelected = selectedServices.contains(label);

    return CheckboxListTile(
      title: Text(label),
      value: isSelected,
      onChanged: (selected) {
        setState(() {
          if (selected!) {
            selectedServices.add(label);
          } else {
            selectedServices.remove(label);
          }
        });
      },
    );
  }

  void excluirUsuario(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir Usuário'),
          content: Text('Deseja realmente excluir este usuário?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  usuarios.removeAt(index);
                });
                saveUsuarios(); // Salva a lista de usuários após a exclusão
                Navigator.of(context).pop();
              },
              child: Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Torna a barra transparente
        elevation: 0, // Remove a sombra
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.blue.withOpacity(0.5),
          // Define a cor do ícone como transparente
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Text(
                  'Cadastro',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Insira suas informações para cadastro',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 32),
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira a senha.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  'Serviços',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    _buildServicoCheckbox(
                        'Informática', servicosSelecionados, setState),
                    _buildServicoCheckbox(
                        'Construção', servicosSelecionados, setState),
                    _buildServicoCheckbox(
                        'Limpeza', servicosSelecionados, setState),
                    // Adicione mais opções de serviços aqui
                  ],
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: cadastrarUsuario,
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
                SizedBox(height: 16.0),
                Text(
                  'Usuários cadastrados:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 8.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: usuarios.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(usuarios[index]['nome']!),
                      subtitle: Text(usuarios[index]['email']!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //  IconButton(
                          //     onPressed: () => editarUsuario(index),
                          //     icon: Icon(Icons.edit),
                          //   ),
                          IconButton(
                            onPressed: () => excluirUsuario(index),
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}