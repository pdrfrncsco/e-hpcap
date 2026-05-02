import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/local_storage/database_service.dart';
import '../../../../core/network/api_error.dart';
import '../../domain/models/texto_liturgico.dart';

class TextoLiturgicoRepository {
  final Dio _dio;
  final DatabaseService _db;

  TextoLiturgicoRepository(this._dio, this._db);

  Future<List<TextoLiturgico>> getTextosLiturgicos({
    String? tipo,
    String? idioma,
    CancelToken? cancelToken,
  }) async {
    try {
      final localTextos = await _db.getTextosLiturgicos(tipo: tipo, idioma: idioma);
      if (localTextos.isNotEmpty) {
        _syncTextosInBackground(tipo: tipo, idioma: idioma, cancelToken: cancelToken);
        return localTextos;
      }
    } catch (e) {
      debugPrint('Erro ao ler textos litúrgicos do banco local: $e');
    }

    return _fetchAndSaveTextos(tipo: tipo, idioma: idioma, cancelToken: cancelToken);
  }

  Future<List<TextoLiturgico>> _fetchAndSaveTextos({
    String? tipo,
    String? idioma,
    CancelToken? cancelToken,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (tipo != null && tipo.isNotEmpty) queryParams['tipo'] = tipo;
      if (idioma != null && idioma.isNotEmpty) queryParams['idioma'] = idioma;

      final response = await _dio.get(
        'textos/',
        queryParameters: queryParams,
        cancelToken: cancelToken,
      );

      final List<dynamic> data = _unwrapList(response.data);
      final textos = data
          .map((json) => TextoLiturgico.fromJson(json as Map<String, dynamic>))
          .toList();

      await _db.saveTextosLiturgicos(textos);
      return textos;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) throw e;
      throw ApiErrorFormatter.fromDio(
        e,
        fallbackMessage: 'Não foi possível carregar os textos litúrgicos.',
      );
    }
  }

  void _syncTextosInBackground({
    String? tipo,
    String? idioma,
    CancelToken? cancelToken,
  }) {
    _fetchAndSaveTextos(
      tipo: tipo,
      idioma: idioma,
      cancelToken: cancelToken,
    ).catchError((e) {
      if (!CancelToken.isCancel(e)) {
        debugPrint('Erro no sync de background de textos litúrgicos: $e');
      }
      return <TextoLiturgico>[];
    });
  }

  List<dynamic> _unwrapList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final results = data['results'];
      if (results is List) return results;
    }
    throw Exception('Resposta inesperada da API: $data');
  }
}
