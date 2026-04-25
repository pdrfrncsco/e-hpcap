import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../../../core/local_storage/database_service.dart';
import '../../../../core/network/api_error.dart';
import '../../domain/models/hino.dart';
import '../../domain/models/tema.dart';

class HinarioRepository {
  final Dio _dio;
  final DatabaseService _db;

  HinarioRepository(this._dio, this._db);

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

  Future<List<Hino>> getHinos({String? secao, String? temaSlug}) async {
    // 1. Tentar ler do banco local primeiro
    try {
      final localHinos = await _db.getHinos(secao: secao, temaSlug: temaSlug);
      if (localHinos.isNotEmpty) {
        // Retornar dados locais imediatamente para alívio imediato
        // Opcionalmente, poderíamos disparar um fetch em background para atualizar
        _syncHinosInBackground(secao: secao, temaSlug: temaSlug);
        return localHinos;
      }
    } catch (e) {
      print('Erro ao ler hinos do banco local: $e');
    }

    // 2. Se não houver dados locais, buscar da rede
    return _fetchAndSaveHinos(secao: secao, temaSlug: temaSlug);
  }

  Future<List<Hino>> _fetchAndSaveHinos({String? secao, String? temaSlug}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (secao != null) queryParams['secao'] = secao;
      if (temaSlug != null) queryParams['tema'] = temaSlug;

      final response = await _dio.get('hinos/', queryParameters: queryParams);
      final List<dynamic> data = _unwrapList(response.data);
      final hinos = data
          .map((json) => Hino.fromJson(json as Map<String, dynamic>))
          .toList();

      // Salvar no banco local para uso futuro
      await _db.saveHinos(hinos);
      
      return hinos;
    } on DioException catch (e) {
      throw ApiErrorFormatter.fromDio(
        e,
        fallbackMessage: 'Não foi possível carregar os hinos.',
      );
    }
  }

  void _syncHinosInBackground({String? secao, String? temaSlug}) {
    _fetchAndSaveHinos(secao: secao, temaSlug: temaSlug).catchError((e) {
      print('Erro no sync de background: $e');
      return <Hino>[];
    });
  }

  Future<Hino> getHinoDetalhe(int id) async {
    // 1. Tentar ler do banco local
    try {
      final localHino = await _db.getHinoDetalhe(id);
      if (localHino != null) {
        return localHino;
      }
    } catch (e) {
      print('Erro ao ler detalhe do hino do banco local: $e');
    }

    // 2. Se não houver ou não for detalhado, buscar da rede
    try {
      final response = await _dio.get('hinos/$id/');
      final hino = Hino.fromJson(response.data as Map<String, dynamic>);
      
      // Salvar no banco local
      await _db.saveHinos([hino]);
      
      return hino;
    } on DioException catch (e) {
      throw ApiErrorFormatter.fromDio(
        e,
        fallbackMessage: 'Não foi possível carregar os detalhes do hino.',
      );
    }
  }

  Future<List<Hino>> buscarHinos(String query, {String? secao}) async {
    // 1. Tentar sempre a rede primeiro para resultados mais precisos (Busca Full-Text no Postgres)
    try {
      final queryParams = <String, dynamic>{'q': query};
      if (secao != null) queryParams['secao'] = secao;

      final response = await _dio.get(
        'hinos/busca/',
        queryParameters: queryParams,
      );

      final List<dynamic> data = _unwrapList(response.data);
      final hinos = data
          .map((json) => Hino.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return hinos;
    } on DioException catch (e) {
      // 2. Fallback Offline: Se a rede falhar (ex: sem internet), procuramos no banco local
      debugPrint('Busca remota falhou, tentando busca local: $e');
      return await _db.searchHinosLocal(query, secao: secao);
    } catch (e) {
      return await _db.searchHinosLocal(query, secao: secao);
    }
  }

  /// Descarrega todos os hinos de uma secção com letras para uso offline completo
  Future<void> descarregarSecaoCompleta(String secao) async {
    try {
      final response = await _dio.get('hinos/', queryParameters: {
        'secao': secao,
        'page_size': 1000, 
        'include_details': 'true', // Ativa o envio das letras em massa
      });
      
      final List<dynamic> data = _unwrapList(response.data);
      final hinos = data
          .map((json) => Hino.fromJson(json as Map<String, dynamic>))
          .toList();

      await _db.saveHinos(hinos);
    } catch (e) {
      debugPrint('Erro ao descarregar secção completa: $e');
      rethrow;
    }
  }

  Future<List<Tema>> getTemas() async {
    // 1. Tentar local
    try {
      final localTemas = await _db.getTemas();
      if (localTemas.isNotEmpty) {
        _syncTemasInBackground();
        return localTemas;
      }
    } catch (e) {
      print('Erro ao ler temas do banco local: $e');
    }

    return _fetchAndSaveTemas();
  }

  Future<List<Tema>> _fetchAndSaveTemas() async {
    try {
      final response = await _dio.get('temas/');
      final List<dynamic> data = _unwrapList(response.data);
      final temas = data
          .map((json) => Tema.fromJson(json as Map<String, dynamic>))
          .toList();

      await _db.saveTemas(temas);
      return temas;
    } on DioException catch (e) {
      throw ApiErrorFormatter.fromDio(
        e,
        fallbackMessage: 'Não foi possível carregar os temas.',
      );
    }
  }

  void _syncTemasInBackground() {
    _fetchAndSaveTemas().catchError((e) => <Tema>[]);
  }
}
