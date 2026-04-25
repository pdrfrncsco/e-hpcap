import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/evento_publicacao.dart';
import '../providers/eventos_providers.dart';

class EventoDetailScreen extends ConsumerWidget {
  final int eventoId;

  const EventoDetailScreen({
    super.key,
    required this.eventoId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventoAsync = ref.watch(eventoDetalheProvider(eventoId));

    return Scaffold(
      body: eventoAsync.when(
        data: (evento) => _EventoDetailView(evento: evento),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}

class _EventoDetailView extends StatelessWidget {
  final EventoPublicacao evento;

  const _EventoDetailView({required this.evento});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 320,
          pinned: true,
          stretch: true,
          backgroundColor: AppColors.primary,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (evento.imagemUrl.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: evento.imagemUrl,
                    fit: BoxFit.cover,
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    memCacheWidth: 1400,
                    placeholder: (_, __) =>
                        _DetailFallbackHeader(evento: evento),
                    errorWidget: (_, __, ___) =>
                        _DetailFallbackHeader(evento: evento),
                  )
                else
                  _DetailFallbackHeader(evento: evento),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x22000000),
                        Color(0xB0000000),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: theme.scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _DetailPill(label: evento.categoria.nome),
                      _DetailPill(label: _labelTipo(evento.tipo)),
                      if (evento.destaque)
                        const _DetailPill(label: 'Em destaque', filled: true),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    evento.titulo,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimaryLight,
                        ),
                  ),
                  if (evento.resumo.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      evento.resumo,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.black87,
                            height: 1.45,
                          ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: theme.colorScheme.outlineVariant),
                    ),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        if (evento.igrejaNome.isNotEmpty)
                          _DetailInfo(
                              icon: Icons.church_outlined,
                              text: evento.igrejaNome),
                        if (evento.publicador.nomeExibicao.isNotEmpty)
                          _DetailInfo(
                            icon: Icons.person_outline,
                            text: evento.publicador.nomeExibicao,
                          ),
                        if (evento.local.isNotEmpty)
                          _DetailInfo(
                              icon: Icons.place_outlined, text: evento.local),
                        if (evento.dataEvento != null)
                          _DetailInfo(
                            icon: Icons.event_outlined,
                            text: _formatDate(evento.dataEvento!),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _EventoActions(evento: evento),
                  const SizedBox(height: 24),
                  Text(
                    'Descrição',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    evento.descricao,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.7,
                          color: Colors.black87,
                        ),
                  ),
                  if (evento.galeriaUrls.length > 1) ...[
                    const SizedBox(height: 28),
                    Text(
                      'Galeria',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 220,
                      child: PageView.builder(
                        controller: PageController(viewportFraction: 0.88),
                        itemCount: evento.galeriaUrls.length,
                        itemBuilder: (context, index) {
                          final imageUrl = evento.galeriaUrls[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                fadeInDuration: Duration.zero,
                                fadeOutDuration: Duration.zero,
                                memCacheWidth: 1200,
                                placeholder: (_, __) => Container(
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                      size: 36,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  if (evento.videoUrl.isNotEmpty ||
                      evento.linkExterno.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    Text(
                      'Recursos',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 12),
                    if (evento.videoUrl.isNotEmpty) ...[
                      _InlineVideoCard(
                          url: evento.videoUrl, titulo: evento.titulo),
                      const SizedBox(height: 12),
                    ],
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        if (evento.videoUrl.isNotEmpty)
                          FilledButton.icon(
                            onPressed: () => _openUrl(evento.videoUrl),
                            icon: const Icon(Icons.play_circle_outline),
                            label: const Text('Reproduzir vídeo'),
                          ),
                        if (evento.linkExterno.isNotEmpty)
                          OutlinedButton.icon(
                            onPressed: () => _openUrl(evento.linkExterno),
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Abrir link do evento'),
                          ),
                      ],
                    ),
                  ],
                  if (evento.contactoEvento.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer
                            .withValues(alpha: 0.55),
                        border:
                            Border.all(color: theme.colorScheme.outlineVariant),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contacto e inscrição',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            evento.contactoEvento,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  height: 1.5,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              FilledButton.tonalIcon(
                                onPressed: () => _contactEvent(
                                    context, evento.contactoEvento),
                                icon: const Icon(Icons.call_outlined),
                                label: const Text('Contactar'),
                              ),
                              if (evento.linkExterno.isNotEmpty)
                                OutlinedButton.icon(
                                  onPressed: () => _openUrl(evento.linkExterno),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: theme.colorScheme.primary,
                                    side: BorderSide(
                                        color:
                                            theme.colorScheme.outlineVariant),
                                  ),
                                  icon: const Icon(Icons.app_registration),
                                  label: const Text('Inscrição'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  Text(
                    'Relacionados',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _RelacionadosSection(evento: evento),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static String _labelTipo(String tipo) {
    switch (tipo) {
      case 'evangelizacao':
        return 'Evangelização';
      case 'video_clipe':
        return 'Video Clipe';
      case 'pregacao':
        return 'Pregação';
      case 'evento':
        return 'Evento';
      default:
        return 'Outro';
    }
  }

  static String _formatDate(DateTime date) {
    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  static Future<void> _openUrl(String rawUrl) async {
    final uri = Uri.tryParse(rawUrl);
    if (uri == null) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> _contactEvent(
      BuildContext context, String contact) async {
    final normalized = contact.replaceAll(' ', '');
    final telUri = Uri.tryParse('tel:$normalized');
    if (telUri != null && await launchUrl(telUri)) {
      return;
    }
    final waUri =
        Uri.tryParse('https://wa.me/${normalized.replaceAll('+', '')}');
    if (waUri != null &&
        await launchUrl(waUri, mode: LaunchMode.externalApplication)) {
      return;
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contacto disponível: $contact')),
      );
    }
  }

  static void _sharePublication(BuildContext context, EventoPublicacao evento) {
    final shareText = evento.linkExterno.isNotEmpty
        ? evento.linkExterno
        : evento.videoUrl.isNotEmpty
            ? evento.videoUrl
            : evento.titulo;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Partilha disponível: $shareText')),
    );
  }
}

class _EventoActions extends ConsumerWidget {
  final EventoPublicacao evento;

  const _EventoActions({required this.evento});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liked = ref.watch(
      eventoInteracaoProvider.select(
        (state) => state.likedIds.contains(evento.id),
      ),
    );
    final favorited = ref.watch(
      eventoInteracaoProvider.select(
        (state) => state.favoritedIds.contains(evento.id),
      ),
    );
    final notifier = ref.read(eventoInteracaoProvider.notifier);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _ActionChipButton(
          icon: liked ? Icons.favorite : Icons.favorite_border,
          label: '${evento.likesCount + (liked ? 1 : 0)} gostos',
          onTap: () => notifier.toggleLike(evento.id),
        ),
        _ActionChipButton(
          icon: favorited ? Icons.bookmark : Icons.bookmark_border,
          label: favorited ? 'Guardado' : 'Guardar',
          onTap: () => notifier.toggleFavorite(evento.id),
        ),
        _ActionChipButton(
          icon: Icons.share_outlined,
          label: 'Partilhar ${evento.partilhasCount}',
          onTap: () => _EventoDetailView._sharePublication(context, evento),
        ),
      ],
    );
  }
}

class _RelacionadosSection extends ConsumerWidget {
  final EventoPublicacao evento;

  const _RelacionadosSection({required this.evento});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relacionadosAsync = ref.watch(eventosRelacionadosProvider(evento));

    return relacionadosAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return const Text(
            'Não há outras publicações relacionadas nesta categoria.',
          );
        }
        return Column(
          children: [
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _RelacionadoCard(item: item),
              ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: CircularProgressIndicator(),
      ),
      error: (_, __) => const Text('Falha ao carregar relacionados.'),
    );
  }
}

class _ActionChipButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionChipButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailFallbackHeader extends StatelessWidget {
  final EventoPublicacao evento;

  const _DetailFallbackHeader({required this.evento});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2D1E73), Color(0xFF0D7A67)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 90, 24, 24),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          evento.titulo,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}

class _DetailPill extends StatelessWidget {
  final String label;
  final bool filled;

  const _DetailPill({
    required this.label,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: filled ? AppColors.primary : const Color(0xFFE9EEF5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: filled ? Colors.white : AppColors.textPrimaryLight,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DetailInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailInfo({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _InlineVideoCard extends StatelessWidget {
  final String url;
  final String titulo;

  const _InlineVideoCard({
    required this.url,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    final thumbnail = _youtubeThumbnail(url);

    return GestureDetector(
      onTap: () => _openVideo(url),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.black,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (thumbnail != null)
              CachedNetworkImage(
                imageUrl: thumbnail,
                fit: BoxFit.cover,
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                memCacheWidth: 1200,
                placeholder: (_, __) => _videoFallback(),
                errorWidget: (_, __, ___) => _videoFallback(),
              )
            else
              _videoFallback(),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x22000000), Color(0xAA000000)],
                ),
              ),
            ),
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow_rounded,
                    size: 42, color: AppColors.primary),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Text(
                'Reproduzir vídeo: $titulo',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _videoFallback() {
    return Container(
      color: const Color(0xFF111827),
      child: const Center(
        child: Icon(Icons.ondemand_video, color: Colors.white70, size: 48),
      ),
    );
  }

  static Future<void> _openVideo(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static String? _youtubeThumbnail(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return null;
    }
    final host = uri.host.toLowerCase();
    String? id;
    if (host.contains('youtube.com')) {
      id = uri.queryParameters['v'];
    } else if (host.contains('youtu.be')) {
      id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }
    if (id == null || id.isEmpty) {
      return null;
    }
    return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
  }
}

class _RelacionadoCard extends StatelessWidget {
  final EventoPublicacao item;

  const _RelacionadoCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        item.galeriaUrls.isNotEmpty ? item.galeriaUrls.first : item.imagemUrl;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.push('/eventos/${item.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: 92,
                height: 92,
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                        memCacheWidth: 320,
                        placeholder: (_, __) => _relatedFallback(),
                        errorWidget: (_, __, ___) => _relatedFallback(),
                      )
                    : _relatedFallback(),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.categoria.nome,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.titulo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.resumo.isNotEmpty ? item.resumo : item.descricao,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black87,
                          height: 1.4,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }

  Widget _relatedFallback() {
    return Container(
      color: const Color(0xFFE9EEF5),
      child: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
    );
  }
}
