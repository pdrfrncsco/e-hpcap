import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/hinario_providers.dart';
import '../../domain/models/hino.dart';

/// Debouncer utility class for search
class Debouncer {
  final Duration duration;
  VoidCallback? _action;

  Debouncer({required this.duration});

  void call(VoidCallback action) {
    _action?.call(); // Cancel previous
    _action = action;
    Future.delayed(duration, () {
      if (_action == action) {
        action();
        _action = null;
      }
    });
  }

  void cancel() {
    _action = null;
  }
}

class HinoSearchScreen extends ConsumerStatefulWidget {
  const HinoSearchScreen({super.key});

  @override
  ConsumerState<HinoSearchScreen> createState() => _HinoSearchScreenState();
}

class _HinoSearchScreenState extends ConsumerState<HinoSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Debouncer _debouncer =
      Debouncer(duration: const Duration(milliseconds: 300));

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    // Reset query on exit so it doesn't leak or affect state elsewhere
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchQueryProvider.notifier).state = '';
    });
    _searchController.dispose();
    _focusNode.dispose();
    _debouncer.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debouncer(() {
      ref.read(searchQueryProvider.notifier).state = query;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).state = '';
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(hinoSearchResultsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Buscar hinos...',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: _clearSearch,
                    iconSize: 20,
                  )
                : null,
          ),
          style: theme.textTheme.titleMedium,
          onChanged: _onSearchChanged,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: _buildBody(searchResults),
    );
  }

  Widget _buildBody(AsyncValue<List<Hino>> searchResults) {
    if (_searchController.text.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search,
        title: 'Buscar Hinos',
        subtitle:
            'Digite um numero, titulo ou parte da letra\npara encontrar hinos.',
      );
    }

    return searchResults.when(
      data: (hinos) {
        if (hinos.isEmpty) {
          return _buildEmptyState(
            icon: Icons.music_note_outlined,
            title: 'Nenhum hino encontrado',
            subtitle: 'Tente buscar com outras palavras.',
          );
        }

        return ListView.builder(
          itemCount: hinos.length,
          itemBuilder: (context, index) {
            final hino = hinos[index];
            return _HinoSearchResultTile(
              hino: hino,
              onTap: () => context.go('/hinario/${hino.id}'),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 56,
              color: theme.colorScheme.primary.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    final theme = Theme.of(context);
    return Center(
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
              'Não foi possível buscar',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.refresh(hinoSearchResultsProvider),
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HinoSearchResultTile extends StatelessWidget {
  final Hino hino;
  final VoidCallback onTap;

  const _HinoSearchResultTile({
    required this.hino,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '${hino.numero}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
        title: Text(
          hino.titulo,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'HPC-${hino.secao.toUpperCase()} ${hino.numero}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: theme.colorScheme.outline,
        ),
        onTap: onTap,
      ),
    );
  }
}
