class EventoCategoria {
  final int id;
  final String nome;
  final String slug;
  final String descricao;
  final String cor;
  final int ordem;

  const EventoCategoria({
    required this.id,
    required this.nome,
    required this.slug,
    required this.descricao,
    required this.cor,
    required this.ordem,
  });

  factory EventoCategoria.fromJson(Map<String, dynamic> json) {
    return EventoCategoria(
      id: json['id'] as int,
      nome: json['nome'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      descricao: json['descricao'] as String? ?? '',
      cor: json['cor'] as String? ?? '#0F766E',
      ordem: json['ordem'] as int? ?? 0,
    );
  }
}
