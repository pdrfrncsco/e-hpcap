// lib/features/hinario/data/repositories/hinario_repository.dart

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../../../core/local_storage/database_service.dart';
import '../../../../core/network/api_error.dart';
import '../../domain/models/hino.dart';
import '../../domain/models/tema.dart';

/// Tipo da callback de progresso do download.
typedef ProgressCallback = void Function(
    int downloaded, int total, String phase);

class HinarioRepository {
  final Dio _dio;
  final DatabaseService _db;

  HinarioRepository(this._dio, this._db);

  List<dynamic> _unwrapList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final results = data['results'];
      if (results is List) return results;
    }
    throw Exception('Resposta inesperada da API: $data');
  }

  Future<List<dynamic>> _getAllPages(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    final allResults = <dynamic>[];
    final params = Map<String, dynamic>.from(queryParameters ?? {});
    params.putIfAbsent('page_size', () => 200);

    var page = 1;
    while (true) {
      final response = await _dio.get(
        path,
        queryParameters: {
          ...params,
          'page': page,
        },
        cancelToken: cancelToken,
      );

      final data = response.data;
      if (data is List) {
        allResults.addAll(data);
        return allResults;
      }

      if (data is Map<String, dynamic>) {
        final results = data['results'];
        if (results is! List) {
          throw Exception('Resposta inesperada da API: $data');
        }

        allResults.addAll(results);
        final next = data['next'];
        if (next is String && next.isNotEmpty) {
          page++;
          continue;
        }
        return allResults;
      }

      throw Exception('Resposta inesperada da API: $data');
    }
  }

  Future<List<Hino>> getHinos({
    String? secao,
    String? temaSlug,
    CancelToken? cancelToken,
  }) async {
    try {
      final localHinos = await _db.getHinos(secao: secao, temaSlug: temaSlug);
      if (localHinos.isNotEmpty) {
        if (localHinos.length == 50) {
          try {
            return await _fetchAndSaveHinos(
              secao: secao,
              temaSlug: temaSlug,
              cancelToken: cancelToken,
            );
          } catch (e) {
            if (e is DioException && CancelToken.isCancel(e)) rethrow;
            debugPrint('Erro ao actualizar cache parcial de hinos: $e');
            return localHinos;
          }
        }
        _syncHinosInBackground(
          secao: secao,
          temaSlug: temaSlug,
          cancelToken: cancelToken,
        );
        return localHinos;
      }
    } catch (e) {
      debugPrint('Erro ao ler hinos do banco local: $e');
    }
    return _fetchAndSaveHinos(
      secao: secao,
      temaSlug: temaSlug,
      cancelToken: cancelToken,
    );
  }

  Future<List<Hino>> _fetchAndSaveHinos({
    String? secao,
    String? temaSlug,
    CancelToken? cancelToken,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (secao != null && secao.isNotEmpty) queryParams['secao'] = secao;
      if (temaSlug != null && temaSlug.isNotEmpty) {
        queryParams['tema'] = temaSlug;
      }

      final data = await _getAllPages(
        'hinos/',
        queryParameters: queryParams,
        cancelToken: cancelToken,
      );
      final hinos = data
          .map((json) => Hino.fromJson(json as Map<String, dynamic>))
          .toList();

      await _db.saveHinos(hinos);
      return hinos;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) throw e;
      throw ApiErrorFormatter.fromDio(
        e,
        fallbackMessage: 'Não foi possível carregar os hinos.',
      );
    }
  }

  void _syncHinosInBackground({
    String? secao,
    String? temaSlug,
    CancelToken? cancelToken,
  }) {
    _fetchAndSaveHinos(
      secao: secao,
      temaSlug: temaSlug,
      cancelToken: cancelToken,
    ).catchError((e) {
      if (!CancelToken.isCancel(e)) {
        debugPrint('Erro no sync de background: $e');
      }
      return <Hino>[];
    });
  }

  Future<Hino> getHinoDetalhe(int id, {CancelToken? cancelToken}) async {
    try {
      final localHino = await _db.getHinoDetalhe(id);
      if (localHino != null) return localHino;
    } catch (e) {
      debugPrint('Erro ao ler detalhe do hino do banco local: $e');
    }

    try {
      final response = await _dio.get(
        'hinos/$id/',
        cancelToken: cancelToken,
      );
      final hino = Hino.fromJson(response.data as Map<String, dynamic>);
      await _db.saveHinos([hino]);
      return hino;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) throw e;
      throw ApiErrorFormatter.fromDio(
        e,
        fallbackMessage: 'Não foi possível carregar os detalhes do hino.',
      );
    }
  }

  /// Busca hinos com fallback automático para local se o servidor falhar ou retornar vazio.
  Future<List<Hino>> buscarHinos(
    String query, {
    String? secao,
    CancelToken? cancelToken,
  }) async {
    if (query.isEmpty) return [];

    List<Hino> results = [];

    // 1. Tentar busca remota primeiro
    try {
      final queryParams = <String, dynamic>{'q': query, 'search': query};
      if (secao != null && secao.isNotEmpty) queryParams['secao'] = secao;

      final response = await _dio.get(
        'hinos/busca/',
        queryParameters: queryParams,
        cancelToken: cancelToken,
      );

      final List<dynamic> data = _unwrapList(response.data);
      results = data
          .map((json) => Hino.fromJson(json as Map<String, dynamic>))
          .toList();

      if (results.isNotEmpty) return results;
    } catch (e) {
      if (CancelToken.isCancel(e as DioException)) throw e;
      debugPrint('Busca remota falhou ou retornou vazio, tentando local: $e');
    }

    // 2. Se remota falhar ou for vazia, buscar localmente
    results = await _db.searchHinosLocal(query, secao: secao);

    // 3. Se ainda estiver vazio e estávamos filtrando por seção, tentar busca GLOBAL
    if (results.isEmpty && secao != null) {
      results = await _db.searchHinosLocal(query, secao: null);
    }

    return results;
  }

  Future<void> descarregarSecaoCompleta(
    String secao, {
    ProgressCallback? onProgress,
    CancelToken? cancelToken,
  }) async {
    onProgress?.call(0, 0, 'A contactar o servidor…');

    late List<Hino> hinos;

    try {
      final data = await _getAllPages(
        'hinos/',
        queryParameters: {
          'secao': secao,
          'page_size': 1000,
          'include_details': 'true',
        },
        cancelToken: cancelToken,
      );

      hinos = data
          .map((json) => Hino.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) throw e;
      throw ApiErrorFormatter.fromDio(
        e,
        fallbackMessage: 'Não foi possível descarregar a secção.',
      );
    }

    final total = hinos.length;
    if (total == 0) return;

    for (int i = 0; i < total; i++) {
      if (cancelToken?.isCancelled ?? false) return;
      await _db.saveHinos([hinos[i]]);
      onProgress?.call(i + 1, total, 'A guardar hino ${i + 1} de $total…');
    }
  }

  Future<List<Tema>> getTemas({CancelToken? cancelToken}) async {
    try {
      final localTemas = await _db.getTemas();
      if (localTemas.isNotEmpty) {
        _syncTemasInBackground(cancelToken: cancelToken);
        return localTemas;
      }
    } catch (e) {
      debugPrint('Erro ao ler temas do banco local: $e');
    }
    return _fetchAndSaveTemas(cancelToken: cancelToken);
  }

  Future<List<Tema>> _fetchAndSaveTemas({CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get('temas/', cancelToken: cancelToken);
      final List<dynamic> data = _unwrapList(response.data);
      final temas = data
          .map((json) => Tema.fromJson(json as Map<String, dynamic>))
          .toList();
      await _db.saveTemas(temas);
      return temas;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) throw e;
      throw ApiErrorFormatter.fromDio(
        e,
        fallbackMessage: 'Não foi possível carregar os temas.',
      );
    }
  }

  void _syncTemasInBackground({CancelToken? cancelToken}) {
    _fetchAndSaveTemas(cancelToken: cancelToken).catchError((e) => <Tema>[]);
  }
}
