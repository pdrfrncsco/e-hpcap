import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiError implements Exception {
  final String message;

  const ApiError(this.message);

  @override
  String toString() => message;
}

class ApiErrorFormatter {
  static ApiError fromDio(
    DioException error, {
    required String fallbackMessage,
  }) {
    final data = error.response?.data;

    if (data is Map) {
      final detail = _extractDetailFromMap(data);
      if (detail != null && detail.isNotEmpty) {
        return ApiError(detail);
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiError('A ligação expirou. Tente novamente.');
      case DioExceptionType.connectionError:
        if (kIsWeb) {
          return const ApiError(
            'Erro de rede ou de segurança (CORS). Verifique a ligação ou as permissões do servidor.',
          );
        }
        return const ApiError(
          'Sem ligação à internet. Verifique e tente novamente.',
        );
      case DioExceptionType.badCertificate:
        return const ApiError('Falha no certificado de segurança da ligação.');
      case DioExceptionType.cancel:
        return const ApiError('Pedido cancelado.');
      case DioExceptionType.badResponse:
        return ApiError(
          _friendlyStatusMessage(error.response?.statusCode),
        );
      case DioExceptionType.unknown:
        return ApiError(fallbackMessage);
    }
  }

  static String _friendlyStatusMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Pedido inválido. Reveja os dados e tente novamente.';
      case 401:
        return 'A sua sessão expirou. Entre novamente.';
      case 403:
        return 'Não tem permissão para realizar esta ação.';
      case 404:
        return 'O recurso pedido não foi encontrado.';
      case 409:
        return 'Já existe um registo com estes dados.';
      case 422:
        return 'Os dados enviados não são válidos.';
      case 500:
        return 'O servidor encontrou um erro. Tente novamente mais tarde.';
      case 502:
      case 503:
      case 504:
        return 'O serviço está indisponível neste momento. Tente novamente.';
      default:
        return 'Não foi possível concluir o pedido.';
    }
  }

  static String? _extractDetailFromMap(Map data) {
    final detail = data['detail'] ?? data['message'] ?? data['error'];
    if (detail is String && detail.trim().isNotEmpty) {
      return detail.trim();
    }

    final errors = <String>[];
    for (final entry in data.entries) {
      final value = entry.value;
      if (value is List && value.isNotEmpty) {
        errors.add(value.join(' '));
      } else if (value is String && value.trim().isNotEmpty) {
        errors.add(value.trim());
      }
    }
    if (errors.isEmpty) return null;
    return errors.first;
  }
}
