import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _pageController = PageController(initialPage: 0);
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _cepController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
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
    final novoUsuario = {
      'nome': _nomeController.text,
      'email': _emailController.text,
      'senha': _senhaController.text,
      'endereco': _enderecoController.text,
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
    _bairroController.clear();
    _cidadeController.clear();
    _estadoController.clear();

    // Salvar usuários no SharedPreferences
    salvarUsuarios();

    // Navegar para a primeira etapa novamente
    _pageController.jumpToPage(0);

    // Exibir diálogo de confirmação e redirecionar para a tela home após 2 segundos
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cadastro Concluído'),
          content: Text('O seu cadastro foi realizado com sucesso!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/home');
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

  Future<void> buscarEnderecoPorCEP(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('erro')) {
        // CEP não encontrado
        setState(() {
          _enderecoController.text = '';
          _bairroController.text = '';
          _cidadeController.text = '';
          _estadoController.text = '';
        });
      } else {
        // Preenche os campos de endereço com os dados encontrados
        setState(() {
          _enderecoController.text = data['logradouro'];
          _bairroController.text = data['bairro'];
          _cidadeController.text = data['localidade'];
          _estadoController.text = data['uf'];
        });
      }
    } else {
      // Erro ao realizar a requisição
      setState(() {
        _enderecoController.text = '';
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Text(
                  'Cadastro',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Insira suas informações',
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: 2,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKeys[index],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (index == 0) ...[
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
                        if (index == 1) ...[
                          TextFormField(
                            controller: _cepController,
                            decoration: InputDecoration(
                              labelText: 'CEP',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.length == 8) {
                                buscarEnderecoPorCEP(value);
                              }
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
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKeys[index].currentState!.validate()) {
                              if (index < 1) {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                cadastrarUsuario();
                              }
                            }
                          },
                          child: Text(index < 1 ? 'Próxima' : 'Cadastrar'),
                        ),
                        if (index > 0) ...[
                          SizedBox(height: 16.0),
                          TextButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text('Voltar'),
                          ),
                        ],
                      ],
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
