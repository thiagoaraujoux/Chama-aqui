class Usuario {
  int? id;
  String nome;
  String email;
  String senha;
  String cep;
  String logradouro; // Novo campo "logradouro"
  String bairro; // Novo campo "bairro"
  String cidade; // Novo campo "cidade"
  String estado; // Novo campo "estado"
  String numero; // Novo campo "numero"
  List<String> servicos;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.numero,
    required this.servicos,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'cep': cep,
      'logradouro': logradouro,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'numero': numero,
      'servicos': servicos,
    };
  }

  static Usuario fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      cep: map['cep'],
      logradouro: map['logradouro'],
      bairro: map['bairro'],
      cidade: map['cidade'],
      estado: map['estado'],
      numero: map['numero'],
      servicos: List<String>.from(map['servicos']),
    );
  }

  String get nomeCompleto {
    return '$nome'; // Você pode modificar o formato conforme necessário
  }

  String get servico {
    if (servicos.isNotEmpty) {
      return servicos[0]; // Retorna o primeiro serviço da lista
    } else {
      return ''; // Retorna uma string vazia se o usuário não tiver nenhum serviço
    }
  }
}
