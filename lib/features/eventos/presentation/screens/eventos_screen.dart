import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/evento_publicacao.dart';
import '../providers/eventos_providers.dart';

class EventosScreen extends ConsumerWidget {
  const EventosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destaquesAsync = ref.watch(eventosDestaqueProvider);
    final feedAsync = ref.watch(eventosFeedProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
        centerTitle: false,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comunidade',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Feed da Comunidade',
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimaryLight),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(eventoCategoriasProvider);
          ref.invalidate(eventosDestaqueProvider);
          ref.invalidate(eventosFeedProvider);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // --- Featured Section ---
            SliverToBoxAdapter(
              child: destaquesAsync.when(
                data: (items) => items.isEmpty
                    ? const SizedBox.shrink()
                    : _FeaturedSection(item: items.first),
                loading: () => const _SectionLoadingPlaceholder(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),

            // --- Upcoming Events Section ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Próximos Eventos',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Ver todos',
                        style: TextStyle(color: AppColors.textSecondaryLight),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: destaquesAsync.when(
                data: (items) => _UpcomingEventsList(items: items),
                loading: () => const _SectionLoadingPlaceholder(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),

            // --- Publications and Notices Section ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                child: Text(
                  'Publicações e Avisos',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            feedAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                        child: Text('Nenhuma publicação encontrada.',
                            style:
                                TextStyle(color: AppColors.textPrimaryLight))),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _PublicationCard(item: items[index]),
                      childCount: items.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary)),
              ),
              error: (error, _) => SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
          ],
        ),
      ),
    );
  }
}

class _FeaturedSection extends StatelessWidget {
  final EventoPublicacao item;
  const _FeaturedSection({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => context.push('/eventos/${item.id}'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: item.imagemUrl.isNotEmpty
                        ? Image.network(item.imagemUrl, fit: BoxFit.cover)
                        : Container(color: Colors.grey[200]),
                  ),
                ),
                if (item.videoUrl.isNotEmpty)
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Icon(Icons.play_arrow,
                        color: Colors.white, size: 34),
                  ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.primaryLight,
                    radius: 18,
                    child:
                        Icon(Icons.church, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.titulo,
                          style: const TextStyle(
                              color: AppColors.textPrimaryLight,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.igrejaNome} • Há 2 dias',
                          style: const TextStyle(
                              color: AppColors.textSecondaryLight,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingEventsList extends StatelessWidget {
  final List<EventoPublicacao> items;
  const _UpcomingEventsList({required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => context.push('/eventos/${item.id}'),
            child: Container(
              width: 180,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: item.imagemUrl.isNotEmpty
                          ? Image.network(item.imagemUrl, fit: BoxFit.cover)
                          : Container(color: Colors.grey[200]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.titulo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppColors.textPrimaryLight,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatSimpleDate(item.dataEvento ?? DateTime.now()),
                          style: const TextStyle(
                              color: AppColors.textSecondaryLight,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatSimpleDate(DateTime date) {
    const months = [
      '',
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez'
    ];
    return '${date.day} ${months[date.month]}';
  }
}

class _PublicationCard extends StatelessWidget {
  final EventoPublicacao item;
  const _PublicationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => context.push('/eventos/${item.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 100,
                height: 80,
                child: item.imagemUrl.isNotEmpty
                    ? Image.network(item.imagemUrl, fit: BoxFit.cover)
                    : Container(color: Colors.grey[200]),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.titulo,
                    style: const TextStyle(
                        color: AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatSimpleDate(item.dataEvento ?? DateTime.now()),
                    style: const TextStyle(
                        color: AppColors.textSecondaryLight, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.resumo.isNotEmpty ? item.resumo : item.descricao,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.textPrimaryLight, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSimpleDate(DateTime date) {
    const months = [
      '',
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez'
    ];
    return '${date.day} ${months[date.month]}';
  }
}

class _SectionLoadingPlaceholder extends StatelessWidget {
  const _SectionLoadingPlaceholder();
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 100,
      child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }
}
