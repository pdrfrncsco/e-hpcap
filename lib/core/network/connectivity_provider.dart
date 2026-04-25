import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../../features/hinario/presentation/providers/hinario_providers.dart';

enum ConnectivityStatus { online, offline }

/// Provider que monitoriza a ligação à API de forma activa.
/// Emite [ConnectivityStatus.online] se o servidor responder, 
/// caso contrário [ConnectivityStatus.offline].
final connectivityStatusProvider = StreamProvider<ConnectivityStatus>((ref) {
  final dio = ref.watch(apiClientProvider).client;
  final controller = StreamController<ConnectivityStatus>();

  // Função para verificar a saúde da API
  Future<void> checkStatus() async {
    try {
      // Usamos um timeout curto para a verificação de saúde
      await dio.get('hinos/', queryParameters: {'limit': 1}, 
        options: Options(
          sendTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
        )
      );
      if (!controller.isClosed) controller.add(ConnectivityStatus.online);
    } catch (e) {
      if (!controller.isClosed) controller.add(ConnectivityStatus.offline);
    }
  }

  // Verificar imediatamente
  checkStatus();

  // Agendar verificação periódica (ex: a cada 20 segundos para não sobrecarregar)
  final timer = Timer.periodic(const Duration(seconds: 20), (_) => checkStatus());

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});
