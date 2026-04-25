import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/hinario_providers.dart';
import '../widgets/hino_card.dart';
import '../widgets/filtros_hinario.dart';
class HinarioScreen extends ConsumerWidget {
  const HinarioScreen({super.key});

  void _confirmDownload(BuildContext context, WidgetRef ref, String secao) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Descarregar Hinário'),
        content: Text('Desejas descarregar todos os hinos da secção "${secao.toUpperCase()}" para uso offline?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('A iniciar download...'), duration: Duration(seconds: 2)),
                );
                await ref.read(hinarioRepositoryProvider).descarregarSecaoCompleta(secao);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Download concluído com sucesso!')),
                  );
                  ref.invalidate(hinosListProvider);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro no download: $e')),
                  );
                }
              }
            },
            child: const Text('Descarregar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hinosAsyncValue = ref.watch(hinosListProvider);
    final secaoAtual = ref.watch(secaoSelecionadaProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hinário'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Download para Offline',
            icon: const Icon(Icons.download_for_offline_rounded),
            onPressed: () => _confirmDownload(context, ref, secaoAtual),
          ),
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.go('/hinario/search'),
          ),
        ],
      ),
      body: Column(
        children: [
          const FiltrosHinario(),
          Expanded(
            child: hinosAsyncValue.when(
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
                  onRefresh: () async => ref.invalidate(hinosListProvider),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: hinos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final hino = hinos[index];
                      return HinoCard(
                        hino: hino,
                        onTap: () => context.go('/hinario/${hino.id}'),
                      );
                    },
                  ),
                );
              },
              loading: () => Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 56,
                        color: theme.colorScheme.error.withValues(alpha: 0.7),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Não foi possível carregar',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(hinosListProvider),
                        child: const Text('Tentar Novamente'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
