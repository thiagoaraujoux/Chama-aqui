import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _cepController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _numeroController = TextEditingController();

  List<Map<String, dynamic>> usuarios = [];
  List<String> servicosSelecionados = [];

  late SharedPreferences _prefs;

  bool _isPasswordVisible = false;

  int _currentStep = 0;

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
        usuarios = List<Map<String, dynamic>>.from(
          (json.decode(usuariosJson) as List<dynamic>).map(
                (item) => Map<String, dynamic>.from(item),
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
      final cep = _cepController.text;
      final logradouro = _logradouroController.text;
      final bairro = _bairroController.text;
      final cidade = _cidadeController.text;
      final estado = _estadoController.text;
      final numero = _numeroController.text;

      setState(() {
        usuarios.add({
          'nome': nome,
          'email': email,
          'senha': senha,
          'cep': cep,
          'logradouro': logradouro,
          'bairro': bairro,
          'cidade': cidade,
          'estado': estado,
          'numero': numero,
          'servicos': List<String>.from(servicosSelecionados),
        });
        _nomeController.clear();
        _emailController.clear();
        _senhaController.clear();
        _cepController.clear();
        _logradouroController.clear();
        _bairroController.clear();
        _cidadeController.clear();
        _estadoController.clear();
        _numeroController.clear();
        servicosSelecionados.clear();
        _currentStep = 0;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmação de Cadastro'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome: $nome'),
                Text('Email: $email'),
                Text('CEP: $cep'),
                Text('Logradouro: $logradouro'),
                Text('Bairro: $bairro'),
                Text('Cidade: $cidade'),
                Text('Estado: $estado'),
                Text('Número: $numero'),
                Text('Serviços: ${servicosSelecionados.join(", ")}'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Confirmar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Usuário cadastrado com sucesso!')),
                  );
                  saveUsuarios(); // Salva a lista de usuários
                },
              ),
            ],
          );
        },
      );
    }
  }

  void editarUsuario(int index) {
    String nome = usuarios[index]['nome']!;
    String email = usuarios[index]['email']!;
    String senha = usuarios[index]['senha']!;
    String cep = usuarios[index]['cep']!;
    String logradouro = usuarios[index]['logradouro']!;
    String bairro = usuarios[index]['bairro']!;
    String cidade = usuarios[index]['cidade']!;
    String estado = usuarios[index]['estado']!;
    String numero = usuarios[index]['numero']!;
    List<String> servicos = List<String>.from(usuarios[index]['servicos']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Usuário'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    initialValue: nome,
                    decoration: InputDecoration(labelText: 'Nome'),
                    onChanged: (value) {
                      nome = value;
                    },
                  ),
                  TextFormField(
                    initialValue: email,
                    decoration: InputDecoration(labelText: 'Email'),
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                  TextFormField(
                    initialValue: senha,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    onChanged: (value) {
                      senha = value;
                    },
                  ),
                  TextFormField(
                    initialValue: cep,
                    decoration: InputDecoration(labelText: 'CEP'),
                    onChanged: (value) {
                      cep = value;
                    },
                  ),
                  TextFormField(
                    initialValue: logradouro,
                    decoration: InputDecoration(labelText: 'Logradouro'),
                    onChanged: (value) {
                      logradouro = value;
                    },
                  ),
                  TextFormField(
                    initialValue: bairro,
                    decoration: InputDecoration(labelText: 'Bairro'),
                    onChanged: (value) {
                      bairro = value;
                    },
                  ),
                  TextFormField(
                    initialValue: cidade,
                    decoration: InputDecoration(labelText: 'Cidade'),
                    onChanged: (value) {
                      cidade = value;
                    },
                  ),
                  TextFormField(
                    initialValue: estado,
                    decoration: InputDecoration(labelText: 'Estado'),
                    onChanged: (value) {
                      estado = value;
                    },
                  ),
                  TextFormField(
                    initialValue: numero,
                    decoration: InputDecoration(labelText: 'Número'),
                    onChanged: (value) {
                      numero = value;
                    },
                  ),
                  SizedBox(height: 16),
                  Text('Serviços'),
                  CheckboxListTile(
                    title: Text('Serviço 1'),
                    value: servicos.contains('Serviço 1'),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          servicos.add('Serviço 1');
                        } else {
                          servicos.remove('Serviço 1');
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Serviço 2'),
                    value: servicos.contains('Serviço 2'),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          servicos.add('Serviço 2');
                        } else {
                          servicos.remove('Serviço 2');
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Serviço 3'),
                    value: servicos.contains('Serviço 3'),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          servicos.add('Serviço 3');
                        } else {
                          servicos.remove('Serviço 3');
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                setState(() {
                  usuarios[index]['nome'] = nome;
                  usuarios[index]['email'] = email;
                  usuarios[index]['senha'] = senha;
                  usuarios[index]['cep'] = cep;
                  usuarios[index]['logradouro'] = logradouro;
                  usuarios[index]['bairro'] = bairro;
                  usuarios[index]['cidade'] = cidade;
                  usuarios[index]['estado'] = estado;
                  usuarios[index]['numero'] = numero;
                  usuarios[index]['servicos'] = servicos;
                });
                Navigator.of(context).pop();
                saveUsuarios();
              },
            ),
          ],
        );
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
          actions: <Widget>[
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
                  usuarios.removeAt(index);
                });
                Navigator.of(context).pop();
                saveUsuarios();
              },
            ),
          ],
        );
      },
    );
  }
  void buscarEndereco(String cep) async {
    final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _logradouroController.text = data['logradouro'];
        _bairroController.text = data['bairro'];
        _cidadeController.text = data['localidade'];
        _estadoController.text = data['uf'];
      });
    } else {
      print('Erro ao buscar endereço');
    }
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return Column(
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um nome válido.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um email válido.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _senhaController,
              decoration: InputDecoration(
                labelText: 'Senha',
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isPasswordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira uma senha válida.';
                }
                return null;
              },
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            TextFormField(
              controller: _cepController,
              decoration: InputDecoration(labelText: 'CEP'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um CEP válido.';
                }
                return null;
              },
              onChanged: (value) {
                if (value.length == 8) {
                  buscarEndereco(value);
                }
              },
            ),

            TextFormField(
              controller: _logradouroController,
              decoration: InputDecoration(labelText: 'Logradouro'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um logradouro válido.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _bairroController,
              decoration: InputDecoration(labelText: 'Bairro'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um bairro válido.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _cidadeController,
              decoration: InputDecoration(labelText: 'Cidade'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira uma cidade válida.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _estadoController,
              decoration: InputDecoration(labelText: 'Estado'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um estado válido.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _numeroController,
              decoration: InputDecoration(labelText: 'Número'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um número válido.';
                }
                return null;
              },
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            CheckboxListTile(
              title: Text('Serviço 1'),
              value: servicosSelecionados.contains('Serviço 1'),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    servicosSelecionados.add('Serviço 1');
                  } else {
                    servicosSelecionados.remove('Serviço 1');
                  }
                });
              },
            ),
            CheckboxListTile(
              title: Text('Serviço 2'),
              value: servicosSelecionados.contains('Serviço 2'),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    servicosSelecionados.add('Serviço 2');
                  } else {
                    servicosSelecionados.remove('Serviço 2');
                  }
                });
              },
            ),
            CheckboxListTile(
              title: Text('Serviço 3'),
              value: servicosSelecionados.contains('Serviço 3'),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    servicosSelecionados.add('Serviço 3');
                  } else {
                    servicosSelecionados.remove('Serviço 3');
                  }
                });
              },
            ),
          ],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepTapped: (step) {
          setState(() {
            _currentStep = step;
          });
        },
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() {
              _currentStep += 1;
            });
          } else {
            cadastrarUsuario();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        steps: [
          Step(
            title: Text('Dados Pessoais'),
            content: _buildStepContent(0),
            isActive: _currentStep == 0,
          ),
          Step(
            title: Text('Endereço'),
            content: _buildStepContent(1),
            isActive: _currentStep == 1,
          ),
          Step(
            title: Text('Serviços'),
            content: _buildStepContent(2),
            isActive: _currentStep == 2,
          ),
        ],
      ),
    );
  }
}
