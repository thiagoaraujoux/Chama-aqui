class ServicoModel {
  final String servico;
  final List<String> categorias;

  ServicoModel({
    required this.servico,
    required this.categorias,
  });
}

List<ServicoModel> servicos = [
  ServicoModel(
    servico: 'Informática',
    categorias: ['Reparo', 'Instalação', 'Upgrade'],
  ),
  ServicoModel(
    servico: 'Reforma',
    categorias: ['Pintor', 'Pedreiro', 'Engenheiro'],
  ),
  ServicoModel(
    servico: 'Informática',
    categorias: ['Reparo', 'Instalação', 'Upgrade'],
  ),
];
