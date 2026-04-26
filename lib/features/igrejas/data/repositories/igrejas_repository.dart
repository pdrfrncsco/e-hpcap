import 'package:dio/dio.dart';

import '../../../../core/network/api_error.dart';
import '../../domain/models/igreja.dart';
import '../../domain/models/conferencia.dart';
import '../../domain/models/distrito.dart';

class IgrejasRepository {
  final Dio _dio;

  IgrejasRepository(this._dio);

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

  Future<List<Conferencia>> getConferencias() async {
    try {
      final response = await _dio.get('conferencias/');
      final List<dynamic> data = _unwrapList(response.data);
      return data
          .map((json) => Conferencia.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiErrorFormatter.fromDio(
        e,
        fallbackMessage: 'Não foi possível carregar as conferências.',
      );
    }
  }

  Future<List<Distrito>> getDistritos({int? conferenciaId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (conferenciaId != null) queryParams['conferencia'] = conferenciaId;

      final response =
          await _dio.get('distritos/', queryParameters: queryParams);
      final List<dynamic> data = _unwrapList(response.data);
      return data
          .map((json) => Distrito.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiErrorFormatter.fromDio(
        e,
        fallbackMessage: 'Não foi possível carregar os distritos.',
      );
    }
  }

  Future<List<Igreja>> getIgrejas({
    String? conferenciaCodigo,
    int? distritoId,
    String? query,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (conferenciaCodigo != null) {
        queryParams['conferencia'] = conferenciaCodigo;
      }
      if (distritoId != null) queryParams['distrito'] = distritoId;
      if (query != null && query.isNotEmpty) queryParams['q'] = query;

      final response = await _dio.get('igrejas/', queryParameters: queryParams);
      final List<dynamic> data = _unwrapList(response.data);
      return data
          .map((json) => Igreja.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiErrorFormatter.fromDio(
        e,
        fallbackMessage: 'Não foi possível carregar as igrejas.',
      );
    }
  }

  Future<Igreja> getIgrejaDetalhe(int id) async {
    try {
      final response = await _dio.get('igrejas/$id/');
      return Igreja.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiErrorFormatter.fromDio(
        e,
        fallbackMessage: 'Não foi possível carregar os detalhes da igreja.',
      );
    }
  }

  Future<List<Igreja>> getIgrejasProximas(double lat, double lng,
      {double raio = 10}) async {
    try {
      final queryParams = {
        'lat': lat,
        'lng': lng,
        'raio': raio,
      };

      final response =
          await _dio.get('igrejas/proximas/', queryParameters: queryParams);
      final List<dynamic> data = _unwrapList(response.data);
      return data
          .map((json) => Igreja.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiErrorFormatter.fromDio(
        e,
        fallbackMessage: 'Não foi possível procurar igrejas próximas.',
      );
    }
  }

  Future<Igreja?> getMyIgreja() async {
    try {
      final response = await _dio.get('igrejas/minha/');
      return Igreja.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  Future<Igreja> createMyIgreja(dynamic data) async {
    try {
      final response = await _dio.post('igrejas/minha/', data: data);
      return Igreja.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiErrorFormatter.fromDio(
        e,
        fallbackMessage: 'Não foi possível configurar a sua igreja.',
      );
    }
  }

  Future<Igreja> updateIgreja(int id, dynamic data) async {
    try {
      final response = await _dio.patch('igrejas/$id/', data: data);
      return Igreja.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiErrorFormatter.fromDio(
        e,
        fallbackMessage: 'Não foi possível atualizar os dados da igreja.',
      );
    }
  }

  Future<Map<String, dynamic>> validarKuid(String kuid) async {
    try {
      final response = await _dio.get(
        'igrejas/validar-kuid/',
        queryParameters: {'kuid': kuid},
      );
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
      return {
        'valid': false,
        'message': 'Não foi possível validar o KUID.',
        'signup_url': 'https://kuid.me',
      };
    } catch (_) {
      return {
        'valid': false,
        'message': 'Não foi possível validar o KUID.',
        'signup_url': 'https://kuid.me',
      };
    }
  }
}
