import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/igrejas_providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/igreja_list_tile.dart';
import '../widgets/igreja_card.dart';
import '../widgets/igrejas_map_widget.dart';

class IgrejasScreen extends ConsumerWidget {
  const IgrejasScreen({super.key});

  void _showRepresentarOnboarding(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.read(authProvider).value != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Representar Minha Igreja'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gostarias que a tua igreja estivesse disponível no diretório para que outros membros a encontrem?',
            ),
            const SizedBox(height: 16),
            const Text(
              'Procedimentos:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Cria uma conta ou faz login.'),
            const Text('• Preenche os dados básicos da igreja.'),
            const Text('• Após validação, a tua igreja ficará visível no mapa e na lista.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Agora não'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              if (isAuthenticated) {
                context.push('/igrejas/minha-igreja');
              } else {
                context.push('/login');
              }
            },
            child: Text(isAuthenticated ? 'Continuar' : 'Entrar e Começar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewType = ref.watch(igrejasViewTypeProvider);
    final igrejasAsyncValue = ref.watch(igrejasListProvider);
    final searchQuery = ref.watch(searchIgrejaQueryProvider);
    final myIgrejaAsync = ref.watch(myIgrejaProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Directório'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {
              // TODO: Abrir bottom sheet de filtros
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(112),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SearchBar(
                  hintText: 'Pesquisar igreja ou pastor...',
                  leading: const Icon(Icons.search),
                  elevation: WidgetStateProperty.all(0),
                  backgroundColor: WidgetStateProperty.all(
                      theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)),
                  onChanged: (value) {
                    ref.read(searchIgrejaQueryProvider.notifier).state = value;
                  },
                  trailing: [
                    if (searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          ref.read(searchIgrejaQueryProvider.notifier).state = '';
                        },
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: SegmentedButton<IgrejasViewType>(
                  segments: const [
                    ButtonSegment(
                      value: IgrejasViewType.lista,
                      icon: Icon(Icons.list_rounded),
                      label: Text('Lista'),
                    ),
                    ButtonSegment(
                      value: IgrejasViewType.grade,
                      icon: Icon(Icons.grid_view_rounded),
                      label: Text('Grelha'),
                    ),
                    ButtonSegment(
                      value: IgrejasViewType.mapa,
                      icon: Icon(Icons.map_rounded),
                      label: Text('Mapa'),
                    ),
                  ],
                  selected: {viewType},
                  onSelectionChanged: (Set<IgrejasViewType> newSelection) {
                    ref.read(igrejasViewTypeProvider.notifier).state =
                        newSelection.first;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: igrejasAsyncValue.when(
        data: (igrejas) {
          if (igrejas.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.church_rounded,
                      size: 64,
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhuma igreja encontrada',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: () => _showRepresentarOnboarding(context, ref),
                      icon: const Icon(Icons.add_location_alt_rounded),
                      label: const Text('Representar Minha Igreja'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (viewType == IgrejasViewType.mapa) {
            return const IgrejasMapWidget();
          }

          if (viewType == IgrejasViewType.grade) {
            return RefreshIndicator(
              onRefresh: () async => ref.invalidate(igrejasListProvider),
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.86,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: igrejas.length,
                itemBuilder: (context, index) {
                  final igreja = igrejas[index];
                  return Hero(
                    tag: 'igreja_foto_${igreja.id}',
                    child: IgrejaCard(
                      igreja: igreja,
                      onTap: () => context.go('/igrejas/${igreja.id}'),
                    ),
                  );
                },
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(igrejasListProvider),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: igrejas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final igreja = igrejas[index];
                return IgrejaListTile(
                  igreja: igreja,
                  onTap: () => context.go('/igrejas/${igreja.id}'),
                );
              },
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
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
                  onPressed: () => ref.invalidate(igrejasListProvider),
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: myIgrejaAsync.when(
        data: (igreja) => igreja != null
            ? FloatingActionButton.extended(
                onPressed: () => context.push('/igrejas/minha-igreja'),
                icon: const Icon(Icons.edit_note_rounded),
                label: const Text('Minha Igreja'),
              )
            : FloatingActionButton.extended(
                onPressed: () => _showRepresentarOnboarding(context, ref),
                icon: const Icon(Icons.add_location_alt_rounded),
                label: const Text('Representar Minha Igreja'),
              ),
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }
}
