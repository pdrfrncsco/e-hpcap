import 'package:dio/dio.dart';

import '../../../../core/network/api_error.dart';
import '../../domain/models/evento_categoria.dart';
import '../../domain/models/evento_publicacao.dart';

class EventosRepository {
  final Dio _dio;

  EventosRepository(this._dio);

  List<dynamic> _unwrapList(dynamic data) {
    if (data is List) {
      return data;
    }
    if (data is Map<String, dynamic>) {
      final results = data['results'];
      if (results is List) {
        return results;
      }
    }
    throw Exception('Resposta inesperada da API: $data');
  }

  Future<List<EventoCategoria>> getCategorias() async {
    try {
      final response = await _dio.get('eventos/categorias/');
      final data = _unwrapList(response.data);
      return data
          .map((json) => EventoCategoria.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiErrorFormatter.fromDio(
        e,
        fallbackMessage: 'Não foi possível carregar as categorias.',
      );
    }
  }

  Future<List<EventoPublicacao>> getPublicacoes({
    String? categoriaSlug,
    bool destaque = false,
    String? query,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (categoriaSlug != null && categoriaSlug.isNotEmpty) {
      queryParameters['categoria_slug'] = categoriaSlug;
    }
    if (destaque) {
      queryParameters['destaque'] = true;
    }
    if (query != null && query.isNotEmpty) {
      queryParameters['q'] = query;
    }

    try {
      final response = await _dio.get(
        'eventos/publicacoes/',
        queryParameters: queryParameters,
      );
      final data = _unwrapList(response.data);
      return data
          .map(
              (json) => EventoPublicacao.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiErrorFormatter.fromDio(
        e,
        fallbackMessage: 'Não foi possível carregar as publicações.',
      );
    }
  }

  Future<EventoPublicacao> getPublicacaoDetalhe(int id) async {
    try {
      final response = await _dio.get('eventos/publicacoes/$id/');
      return EventoPublicacao.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiErrorFormatter.fromDio(
        e,
        fallbackMessage: 'Não foi possível carregar os detalhes do evento.',
      );
    }
  }
}
