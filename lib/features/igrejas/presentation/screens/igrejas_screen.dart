import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/igrejas_providers.dart';
import '../widgets/igreja_list_tile.dart';
import '../widgets/igreja_card.dart';
import '../widgets/igrejas_map_widget.dart';

class IgrejasScreen extends ConsumerWidget {
  const IgrejasScreen({super.key});

  void _showRepresentarIgrejaDialog(
    BuildContext context, {
    required bool isAuthenticatedMember,
  }) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);

        void closeAndGo(String route) {
          Navigator.of(dialogContext).pop();
          context.push(route);
        }

        return AlertDialog(
          icon: Icon(
            Icons.verified_user_rounded,
            color: theme.colorScheme.primary,
          ),
          title: const Text('Representar Minha Igreja'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Para a tua igreja aparecer no directório, primeiro precisamos confirmar que és um membro autorizado a representar essa igreja.',
                ),
                const SizedBox(height: 16),
                _RepresentarStep(
                  icon: Icons.account_circle_outlined,
                  text: isAuthenticatedMember
                      ? 'Continua com a tua conta de membro.'
                      : 'Entra ou cria uma conta de membro.',
                ),
                const SizedBox(height: 10),
                const _RepresentarStep(
                  icon: Icons.church_outlined,
                  text: 'Informa o KUID da igreja e o teu contacto.',
                ),
                const SizedBox(height: 10),
                const _RepresentarStep(
                  icon: Icons.fact_check_outlined,
                  text:
                      'A solicitação será analisada antes de a igreja ficar disponível no directório.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Agora não'),
            ),
            if (isAuthenticatedMember)
              FilledButton(
                onPressed: () => closeAndGo('/profile'),
                child: const Text('Continuar'),
              )
            else ...[
              TextButton(
                onPressed: () => closeAndGo('/register'),
                child: const Text('Criar conta'),
              ),
              FilledButton(
                onPressed: () => closeAndGo('/login'),
                child: const Text('Entrar'),
              ),
            ],
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewType = ref.watch(igrejasViewTypeProvider);
    final igrejasAsyncValue = ref.watch(igrejasListProvider);
    final searchQuery = ref.watch(searchIgrejaQueryProvider);
    final myIgrejaAsync = ref.watch(myIgrejaProvider);
    final currentUserAsync = ref.watch(currentUserProvider);
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SearchBar(
                  hintText: 'Pesquisar igreja ou pastor...',
                  leading: const Icon(Icons.search),
                  elevation: WidgetStateProperty.all(0),
                  backgroundColor: WidgetStateProperty.all(theme
                      .colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5)),
                  onChanged: (value) {
                    ref.read(searchIgrejaQueryProvider.notifier).state = value;
                  },
                  trailing: [
                    if (searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          ref.read(searchIgrejaQueryProvider.notifier).state =
                              '';
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
        data: (igreja) {
          if (igreja != null) {
            return FloatingActionButton.extended(
              onPressed: () => context.push('/igrejas/minha-igreja'),
              icon: const Icon(Icons.edit_note_rounded),
              label: const Text('Minha Igreja'),
            );
          }

          final currentUser = currentUserAsync.value;
          if (currentUser?.role == 'igreja') {
            return FloatingActionButton.extended(
              onPressed: () => context.push('/igrejas/minha-igreja'),
              icon: const Icon(Icons.add_business_rounded),
              label: const Text('Minha Igreja'),
            );
          }

          return FloatingActionButton.extended(
            onPressed: () => _showRepresentarIgrejaDialog(
              context,
              isAuthenticatedMember: currentUser?.role == 'membro',
            ),
            icon: const Icon(Icons.verified_user_rounded),
            label: const Text('Representar Minha Igreja'),
          );
        },
        loading: () => null,
        error: (_, __) => FloatingActionButton.extended(
          onPressed: () => _showRepresentarIgrejaDialog(
            context,
            isAuthenticatedMember: currentUserAsync.value?.role == 'membro',
          ),
          icon: const Icon(Icons.verified_user_rounded),
          label: const Text('Representar Minha Igreja'),
        ),
      ),
    );
  }
}

class _RepresentarStep extends StatelessWidget {
  final IconData icon;
  final String text;

  const _RepresentarStep({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
