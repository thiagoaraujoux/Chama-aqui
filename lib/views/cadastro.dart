import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _cepController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  List<dynamic> _usuarios = [];
  int _currentPageIndex = 0;

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

  Future<void> cadastrarUsuario() async {
    final novoUsuario = {
      'nome': _nomeController.text,
      'email': _emailController.text,
      'senha': _senhaController.text,
      'endereco': _enderecoController.text,
      'numero': _numeroController.text,
      'bairro': _bairroController.text,
      'cidade': _cidadeController.text,
      'estado': _estadoController.text,
    };

    setState(() {
      _usuarios.add(novoUsuario);
    });

    _nomeController.clear();
    _emailController.clear();
    _senhaController.clear();
    _cepController.clear();
    _enderecoController.clear();
    _numeroController.clear();
    _bairroController.clear();
    _cidadeController.clear();
    _estadoController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Dados cadastrados'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Nome: ${novoUsuario['nome']}'),
            Text('E-mail: ${novoUsuario['email']}'),
            Text('Endereço: ${novoUsuario['endereco']}'),
            Text('Número: ${novoUsuario['numero']}'),
            Text('Bairro: ${novoUsuario['bairro']}'),
            Text('Cidade: ${novoUsuario['cidade']}'),
            Text('Estado: ${novoUsuario['estado']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Fechar'),
          ),
        ],
      ),
    );
    // Salvar usuários no SharedPreferences
    salvarUsuarios();
    await Future.delayed(Duration(seconds: 4));
    Navigator.of(context).pushReplacementNamed('/home');
  }

  Future<void> salvarUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final usuariosJson = json.encode(_usuarios);
    await prefs.setString('usuarios', usuariosJson);
  }

  Future<void> buscarEnderecoPorCEP(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('erro')) {
        // CEP não encontrado
        setState(() {
          _enderecoController.text = '';
          _numeroController.text = '';
          _bairroController.text = '';
          _cidadeController.text = '';
          _estadoController.text = '';
        });
      } else {
        // Preenche os campos de endereço com os dados encontrados
        setState(() {
          _enderecoController.text = data['logradouro'];
          _numeroController.text = '';
          _bairroController.text = data['bairro'];
          _cidadeController.text = data['localidade'];
          _estadoController.text = data['uf'];
        });
      }
    } else {
      // Erro ao realizar a requisição
      setState(() {
        _enderecoController.text = '';
        _numeroController.text = '';
        _bairroController.text = '';
        _cidadeController.text = '';
        _estadoController.text = '';
      });
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
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Cadastro de Usuário',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                    child: Text(
                      'Insira suas informações',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Stepper(
                    currentStep: _currentPageIndex,
                    onStepContinue: () {
                      if (_formKeys[_currentPageIndex].currentState!.validate()) {
                        setState(() {
                          if (_currentPageIndex < _formKeys.length - 1) {
                            _currentPageIndex += 1;
                          } else {
                            cadastrarUsuario();
                          }
                        });
                      }
                    },
                    onStepCancel: () {
                      setState(() {
                        if (_currentPageIndex > 0) {
                          _currentPageIndex -= 1;
                        }
                      });
                    },
                    steps: [
                      Step(
                        title: Text('Informações pessoais'),
                        content: Form(
                          key: _formKeys[0],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 4),
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
                            ],
                          ),
                        ),
                        isActive: _currentPageIndex == 0,
                      ),
                      Step(
                        title: Text('Endereço'),
                        content: Form(
                          key: _formKeys[1],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 4),
                              TextFormField(
                                controller: _cepController,
                                decoration: InputDecoration(
                                  labelText: 'CEP',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  buscarEnderecoPorCEP(value);
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor, insira o CEP.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _enderecoController,
                                decoration: InputDecoration(
                                  labelText: 'Endereço',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor, insira o endereço.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _numeroController,
                                decoration: InputDecoration(
                                  labelText: 'Número',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor, insira o número.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _bairroController,
                                decoration: InputDecoration(
                                  labelText: 'Bairro',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor, insira o bairro.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _cidadeController,
                                decoration: InputDecoration(
                                  labelText: 'Cidade',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor, insira a cidade.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _estadoController,
                                decoration: InputDecoration(
                                  labelText: 'Estado',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor, insira o estado.';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        isActive: _currentPageIndex == 1,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
