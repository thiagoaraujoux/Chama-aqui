class Usuario {
  int? id;
  String nome;
  String email;
  String senha;
  String cep; // Adicionado o campo "cep"
  List<String> servicos;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.cep,
    required this.servicos,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'cep': cep,
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
      servicos: List<String>.from(map['servicos']),
    );
  }

  String get nomeCompleto {
    return '$nome'; // You can modify the format as per your requirement
  }

  String get servico {
    if (servicos.isNotEmpty) {
      return servicos[0]; // Returns the first service from the list
    } else {
      return ''; // Returns an empty string if the user doesn't have any services
    }
  }
}