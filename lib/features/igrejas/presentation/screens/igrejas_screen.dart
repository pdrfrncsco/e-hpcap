import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/igrejas_providers.dart';
import '../widgets/igreja_list_tile.dart';
import '../widgets/igreja_card.dart';
import '../widgets/igrejas_map_widget.dart';

class IgrejasScreen extends ConsumerWidget {
  const IgrejasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewType = ref.watch(igrejasViewTypeProvider);
    final igrejasAsyncValue = ref.watch(igrejasListProvider);
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
          preferredSize: const Size.fromHeight(52),
          child: Padding(
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
                  label: Text('Grade'),
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
                  return IgrejaCard(
                    igreja: igreja,
                    onTap: () => context.go('/igrejas/${igreja.id}'),
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
    );
  }
}
