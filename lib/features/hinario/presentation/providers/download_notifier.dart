// lib/features/hinario/presentation/providers/download_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../data/repositories/hinario_repository.dart';
import 'hinario_providers.dart';

class DownloadState {
  final bool isDownloading;
  final int downloaded;
  final int total;
  final String phase;
  final String? error;
  final bool isComplete;
  final String? secao;
  final bool isCancelled;

  const DownloadState({
    this.isDownloading = false,
    this.downloaded = 0,
    this.total = 0,
    this.phase = '',
    this.error,
    this.isComplete = false,
    this.secao,
    this.isCancelled = false,
  });

  double get progress => total > 0 ? (downloaded / total).clamp(0.0, 1.0) : 0.0;
  bool get hasError => error != null;

  DownloadState copyWith({
    bool? isDownloading,
    int? downloaded,
    int? total,
    String? phase,
    String? error,
    bool? isComplete,
    String? secao,
    bool? isCancelled,
  }) {
    return DownloadState(
      isDownloading: isDownloading ?? this.isDownloading,
      downloaded: downloaded ?? this.downloaded,
      total: total ?? this.total,
      phase: phase ?? this.phase,
      error: error, // null limpa o erro
      isComplete: isComplete ?? this.isComplete,
      secao: secao ?? this.secao,
      isCancelled: isCancelled ?? this.isCancelled,
    );
  }
}

class DownloadNotifier extends StateNotifier<DownloadState> {
  final HinarioRepository _repository;
  CancelToken? _cancelToken;

  DownloadNotifier(this._repository) : super(const DownloadState());

  Future<void> descarregarSecao(String secao) async {
    if (state.isDownloading) return;

    _cancelToken = CancelToken();

    // Preservamos o progresso anterior se for a mesma secção (retry parcial)
    final isRetry = state.secao == secao && state.hasError;
    
    state = state.copyWith(
      isDownloading: true,
      error: null,
      phase: isRetry ? 'A retomar download…' : 'A contactar o servidor…',
      secao: secao,
      isCancelled: false,
    );

    try {
      await _repository.descarregarSecaoCompleta(
        secao,
        cancelToken: _cancelToken,
        onProgress: (int downloaded, int total, String phase) {
          state = state.copyWith(
            downloaded: downloaded,
            total: total,
            phase: phase,
          );
        },
      );

      state = state.copyWith(
        isDownloading: false,
        isComplete: true,
        downloaded: state.total,
        phase: 'Concluído',
      );
    } catch (e) {
      if (CancelToken.isCancel(e as DioException)) {
        state = state.copyWith(
          isDownloading: false,
          isCancelled: true,
          phase: 'Cancelado',
        );
      } else {
        state = state.copyWith(
          isDownloading: false,
          error: e.toString().replaceAll('Exception: ', ''),
          phase: 'Falhou',
        );
      }
    } finally {
      _cancelToken = null;
    }
  }

  void cancelarDownload() => _cancelToken?.cancel();
  void reset() => state = const DownloadState();

  @override
  void dispose() {
    _cancelToken?.cancel();
    super.dispose();
  }
}

final downloadNotifierProvider =
    StateNotifierProvider<DownloadNotifier, DownloadState>((ref) {
  final repository = ref.watch(hinarioRepositoryProvider);
  return DownloadNotifier(repository);
});
