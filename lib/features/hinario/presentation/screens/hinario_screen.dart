// lib/features/hinario/presentation/screens/hinario_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/hinario_providers.dart';
import '../providers/download_notifier.dart';
import '../../../../core/network/connectivity_provider.dart';
import '../widgets/hino_card.dart';
import '../widgets/filtros_hinario.dart';

const _nomesSecao = {
  'pt': 'Português',
  'kim': 'Kimbundu',
  'umb': 'Umbundu',
  'kik': 'Kikongo',
};

final _secoesOrdem = ['pt', 'kim', 'umb', 'kik'];

class HinarioScreen extends ConsumerStatefulWidget {
  const HinarioScreen({super.key});

  @override
  ConsumerState<HinarioScreen> createState() => _HinarioScreenState();
}

class _HinarioScreenState extends ConsumerState<HinarioScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Inicializar o controller com a página correta baseada no estado atual
    final secaoInicial = ref.read(secaoSelecionadaProvider);
    final indexInicial = _secoesOrdem.indexOf(secaoInicial);
    _pageController = PageController(initialPage: indexInicial >= 0 ? indexInicial : 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _iniciarDownload(BuildContext context, String secao) {
    final nomeSecao = _nomesSecao[secao] ?? secao.toUpperCase();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Guardar para uso offline'),
        content: Text(
          'Desejas descarregar todos os hinos da secção "$nomeSecao" '
          'com as letras completas para uso sem internet?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.download_rounded, size: 18),
            label: const Text('Descarregar'),
            onPressed: () {
              Navigator.pop(dialogContext);
              ref.read(downloadNotifierProvider.notifier).descarregarSecao(secao);
              _mostrarFolhaProgresso(context);
            },
          ),
        ],
      ),
    );
  }

  void _mostrarFolhaProgresso(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => _DownloadProgressSheet(
        onComplete: (int total, String secao) {
          if (context.mounted) Navigator.pop(sheetContext);
          ref.read(downloadNotifierProvider.notifier).reset();
          ref.invalidate(hinosPorSecaoProvider(secao));

          final nomeSecao = _nomesSecao[secao] ?? secao.toUpperCase();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('$total hinos de "$nomeSecao" guardados offline com sucesso.'),
                  ),
                ],
              ),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final secaoAtual = ref.watch(secaoSelecionadaProvider);
    final connectivityAsync = ref.watch(connectivityStatusProvider);
    final theme = Theme.of(context);
    final isOffline = connectivityAsync.value == ConnectivityStatus.offline;

    // Escutar mudanças no provider para animar o PageView (se vier de um clique no Chip)
    ref.listen<String>(secaoSelecionadaProvider, (previous, next) {
      final targetPage = _secoesOrdem.indexOf(next);
      if (targetPage >= 0 && _pageController.hasClients && _pageController.page?.round() != targetPage) {
        _pageController.animateToPage(
          targetPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Hinário'),
            if (isOffline)
              Text(
                'Modo Offline',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Guardar para uso offline',
            icon: Icon(
              isOffline ? Icons.cloud_off_rounded : Icons.download_for_offline_rounded,
              color: isOffline ? theme.colorScheme.error : null,
            ),
            onPressed: isOffline 
                ? () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Liga-te à internet para descarregar o hinário completo.'),
                      behavior: SnackBarBehavior.floating,
                    )
                  )
                : () => _iniciarDownload(context, secaoAtual),
          ),
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.go('/hinario/search'),
          ),
        ],
      ),
      body: Column(
        children: [
          if (isOffline)
            Container(
              width: double.infinity,
              color: theme.colorScheme.surfaceContainerHighest,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(
                    'A mostrar hinos guardados no dispositivo',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          const FiltrosHinario(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _secoesOrdem.length,
              onPageChanged: (index) {
                // Atualizar o provider quando o utilizador desliza
                ref.read(secaoSelecionadaProvider.notifier).state = _secoesOrdem[index];
              },
              itemBuilder: (context, index) {
                final secao = _secoesOrdem[index];
                return _ListaHinosSecao(secao: secao, isOffline: isOffline);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget interno para gerir a lista de cada secção de forma independente
class _ListaHinosSecao extends ConsumerWidget {
  final String secao;
  final bool isOffline;

  const _ListaHinosSecao({required this.secao, required this.isOffline});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hinosAsync = ref.watch(hinosPorSecaoProvider(secao));
    final theme = Theme.of(context);

    return hinosAsync.when(
      data: (hinos) {
        if (hinos.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.library_music_outlined,
                    size: 64,
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum hino encontrado',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(hinosPorSecaoProvider(secao)),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: hinos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final hino = hinos[index];
              final isDownloaded = hino.estrofes != null && hino.estrofes!.isNotEmpty;

              return HinoCard(
                hino: hino,
                onTap: () {
                  if (!isDownloaded && isOffline) {
                    _mostrarAvisoOffline(context, hino.titulo);
                  } else {
                    context.go('/hinario/${hino.id}');
                  }
                },
              );
            },
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator(color: theme.colorScheme.primary)),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 56, color: theme.colorScheme.error.withValues(alpha: 0.7)),
              const SizedBox(height: 20),
              Text('Não foi possível carregar', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(error.toString(), textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: () => ref.invalidate(hinosPorSecaoProvider(secao)), child: const Text('Tentar Novamente')),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarAvisoOffline(BuildContext context, String titulo) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.cloud_off_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Letra de "$titulo" não disponível offline. Liga-te para ler.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange.shade800,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(label: 'OK', textColor: Colors.white, onPressed: () {}),
      ),
    );
  }
}

class _DownloadProgressSheet extends ConsumerWidget {
  final void Function(int total, String secao) onComplete;

  const _DownloadProgressSheet({required this.onComplete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final downloadState = ref.watch(downloadNotifierProvider);
    final progress = downloadState.progress;
    final nomeSecao = _nomesSecao[downloadState.secao] ?? '';

    ref.listen<DownloadState>(downloadNotifierProvider, (previous, next) {
      if (next.isComplete && !next.isDownloading) {
        onComplete(next.total, next.secao ?? '');
      }
    });

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: (downloadState.hasError ? theme.colorScheme.errorContainer : theme.colorScheme.primaryContainer).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  downloadState.hasError ? Icons.error_outline_rounded : (downloadState.isComplete ? Icons.check_rounded : Icons.download_rounded),
                  color: downloadState.hasError ? theme.colorScheme.error : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      downloadState.hasError ? 'Erro no download' : (downloadState.isComplete ? 'Download concluído!' : 'A descarregar "$nomeSecao"'),
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    if (downloadState.total > 0 && !downloadState.hasError)
                      Text(
                        '${downloadState.downloaded} de ${downloadState.total} hinos',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                  ],
                ),
              ),
              if (downloadState.hasError || downloadState.isCancelled)
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.read(downloadNotifierProvider.notifier).reset();
                  },
                  icon: const Icon(Icons.close),
                ),
            ],
          ),
          const SizedBox(height: 24),
          if (!downloadState.hasError) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: downloadState.total > 0 ? progress : null,
                minHeight: 8,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
              ),
            ),
            const SizedBox(height: 12),
            Text(downloadState.phase, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ] else ...[
            Text(
              downloadState.error ?? 'Ocorreu um erro inesperado.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => ref.read(downloadNotifierProvider.notifier).descarregarSecao(downloadState.secao!),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Tentar Novamente'),
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (downloadState.isDownloading)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => ref.read(downloadNotifierProvider.notifier).cancelarDownload(),
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('Cancelar'),
                ),
              ],
            ),
          if (downloadState.isDownloading) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 16, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Mantém a aplicação aberta enquanto o download decorre.',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
