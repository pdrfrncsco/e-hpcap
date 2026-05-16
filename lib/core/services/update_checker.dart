import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/update_info.dart';
import '../../features/hinario/presentation/providers/hinario_providers.dart';

class UpdateCheckResult {
  final bool hasUpdate;
  final UpdateInfo? info;
  final int currentVersionCode;

  const UpdateCheckResult({
    required this.hasUpdate,
    required this.currentVersionCode,
    this.info,
  });
}

class UpdateCheckerService {
  final Dio _dio;

  UpdateCheckerService(this._dio);

  Future<UpdateCheckResult> checkForUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;

    try {
      final response = await _dio.get(
        'app/version/',
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      final info = UpdateInfo.fromJson(response.data as Map<String, dynamic>);
      final hasUpdate = info.latestVersionCode > currentVersionCode;

      return UpdateCheckResult(
        hasUpdate: hasUpdate,
        currentVersionCode: currentVersionCode,
        info: hasUpdate ? info : null,
      );
    } catch (e) {
      // Falha silenciosa — não bloquear o utilizador por falha de rede
      return UpdateCheckResult(hasUpdate: false, currentVersionCode: currentVersionCode);
    }
  }
}

final updateCheckerProvider = Provider<UpdateCheckerService>((ref) {
  final dio = ref.watch(apiClientProvider).client;
  return UpdateCheckerService(dio);
});

final updateCheckResultProvider = FutureProvider<UpdateCheckResult>((ref) async {
  return ref.watch(updateCheckerProvider).checkForUpdate();
});
