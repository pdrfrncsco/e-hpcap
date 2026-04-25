import 'evento_categoria.dart';

class EventoPublicador {
  final int id;
  final String nomeExibicao;
  final String cargo;
  final String bio;
  final String contacto;
  final String igrejaNome;

  const EventoPublicador({
    required this.id,
    required this.nomeExibicao,
    required this.cargo,
    required this.bio,
    required this.contacto,
    required this.igrejaNome,
  });

  factory EventoPublicador.fromJson(Map<String, dynamic> json) {
    return EventoPublicador(
      id: json['id'] as int? ?? 0,
      nomeExibicao: json['nome_exibicao'] as String? ?? '',
      cargo: json['cargo'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      contacto: json['contacto'] as String? ?? '',
      igrejaNome: json['igreja_nome'] as String? ?? '',
    );
  }
}

class EventoPublicacao {
  final int id;
  final String titulo;
  final String resumo;
  final String descricao;
  final String tipo;
  final String imagemUrl;
  final List<String> galeriaUrls;
  final String videoUrl;
  final String linkExterno;
  final String contactoEvento;
  final String local;
  final DateTime? dataEvento;
  final DateTime? publicadoEm;
  final bool destaque;
  final int likesCount;
  final int favoritosCount;
  final int partilhasCount;
  final EventoCategoria categoria;
  final EventoPublicador publicador;
  final String igrejaNome;

  const EventoPublicacao({
    required this.id,
    required this.titulo,
    required this.resumo,
    required this.descricao,
    required this.tipo,
    required this.imagemUrl,
    required this.galeriaUrls,
    required this.videoUrl,
    required this.linkExterno,
    required this.contactoEvento,
    required this.local,
    required this.dataEvento,
    required this.publicadoEm,
    required this.destaque,
    required this.likesCount,
    required this.favoritosCount,
    required this.partilhasCount,
    required this.categoria,
    required this.publicador,
    required this.igrejaNome,
  });

  factory EventoPublicacao.fromJson(Map<String, dynamic> json) {
    return EventoPublicacao(
      id: json['id'] as int? ?? 0,
      titulo: json['titulo'] as String? ?? '',
      resumo: json['resumo'] as String? ?? '',
      descricao: json['descricao'] as String? ?? '',
      tipo: json['tipo'] as String? ?? 'evento',
      imagemUrl: json['imagem_url'] as String? ?? '',
      galeriaUrls: _parseStringList(json['galeria_urls']),
      videoUrl: json['video_url'] as String? ?? '',
      linkExterno: json['link_externo'] as String? ?? '',
      contactoEvento: json['contacto_evento'] as String? ?? '',
      local: json['local'] as String? ?? '',
      dataEvento: _parseDate(json['data_evento']),
      publicadoEm: _parseDate(json['publicado_em']),
      destaque: json['destaque'] as bool? ?? false,
      likesCount: json['likes_count'] as int? ?? 0,
      favoritosCount: json['favoritos_count'] as int? ?? 0,
      partilhasCount: json['partilhas_count'] as int? ?? 0,
      categoria: EventoCategoria.fromJson(
        Map<String, dynamic>.from((json['categoria'] as Map?) ?? const {}),
      ),
      publicador: EventoPublicador.fromJson(
        Map<String, dynamic>.from((json['publicador'] as Map?) ?? const {}),
      ),
      igrejaNome: json['igreja_nome'] as String? ?? '',
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is! String || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value);
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is! List) {
      return const [];
    }
    return value
        .whereType<String>()
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}
