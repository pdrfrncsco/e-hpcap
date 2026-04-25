import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../hinario/presentation/providers/hinario_providers.dart';
class UpgradeRepository {
  final Dio _dio;

  UpgradeRepository(this._dio);

  Future<void> requestUpgrade(String kuid, String telefone) async {
    try {
      await _dio.post('/users/upgrade-requests/', data: {
        'kuid_igreja': kuid,
        'telefone_representante': telefone,
      });
    } on DioException catch (e) {
      final message = e.response?.data is Map 
          ? (e.response?.data as Map).values.first.toString()
          : "Erro ao enviar pedido";
      throw message;
    }
  }

  Future<List<Map<String, dynamic>>> getMyRequests() async {

    try {
      final response = await _dio.get('/users/upgrade-requests/');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      return [];
    }
  }
}

final upgradeRepositoryProvider = Provider<UpgradeRepository>((ref) {
  final dio = ref.watch(apiClientProvider).client;
  return UpgradeRepository(dio);
});
