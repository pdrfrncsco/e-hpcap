import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import '../providers/igrejas_providers.dart';

class IgrejaDetalheScreen extends ConsumerWidget {
  final int igrejaId;
  static const double _expandedAppBarHeight = 250;

  const IgrejaDetalheScreen({super.key, required this.igrejaId});

  Future<void> _abrirLink(String urlStr) async {
    final uri = Uri.parse(urlStr);
    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('Não foi possível abrir o link: $urlStr');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(igrejaDetalheProvider(igrejaId));
    final myIgrejaAsync = ref.watch(myIgrejaProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: asyncValue.when(
        data: (igreja) {
          final isManager = myIgrejaAsync.value?.id == igreja.id;
          final cidade = igreja.cidade.trim();
          final morada = (igreja.morada ?? '').trim();

          final confInfo = [
            if (igreja.distrito?.nome != null) igreja.distrito!.nome,
            if (igreja.distrito?.conferencia?.codigo != null)
              igreja.distrito!.conferencia!.codigo,
          ].join(' • ');

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: _expandedAppBarHeight,
                pinned: true,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final topPadding = MediaQuery.paddingOf(context).top;
                    final collapsedHeight = kToolbarHeight + topPadding;
                    final showTitle =
                        constraints.maxHeight <= collapsedHeight + 18;

                    return FlexibleSpaceBar(
                      titlePadding: const EdgeInsetsDirectional.only(
                        start: 72,
                        bottom: 16,
                        end: 16,
                      ),
                      title: AnimatedOpacity(
                        opacity: showTitle ? 1 : 0,
                        duration: const Duration(milliseconds: 220),
                        child: Text(
                          igreja.nome,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      background: Hero(
                        tag: 'igreja_foto_${igreja.id}',
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            igreja.foto != null
                                ? CachedNetworkImage(
                                    imageUrl: igreja.foto!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: theme.colorScheme
                                          .surfaceContainerHighest,
                                      highlightColor:
                                          theme.colorScheme.surface,
                                      child: Container(color: Colors.white),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: theme.colorScheme.primaryContainer,
                                      child: Icon(
                                        Icons.church,
                                        size: 80,
                                        color: theme.colorScheme
                                            .onPrimaryContainer,
                                      ),
                                    ),
                                  )
                                : Container(
                                    color: theme.colorScheme.primaryContainer,
                                    child: Icon(
                                      Icons.church,
                                      size: 80,
                                      color: theme
                                          .colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.1),
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.28),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                actions: [
                  if (isManager)
                    IconButton(
                      icon: const Icon(Icons.edit_note_rounded),
                      onPressed: () => context.push('/igrejas/minha-igreja'),
                    ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: theme.colorScheme.outlineVariant),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              igreja.nome,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (confInfo.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                confInfo,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            if (igreja.dataFundacao != null &&
                                igreja.dataFundacao!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Fundada em ${igreja.dataFundacao}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildInfoRow(
                        context,
                        Icons.person,
                        'Pastor Responsável',
                        igreja.pastor,
                      ),
                      const SizedBox(height: 16),
                      if (igreja.horarioCulto != null &&
                          igreja.horarioCulto!.isNotEmpty) ...[
                        _buildInfoRow(
                          context,
                          Icons.access_time,
                          'Horários de Culto',
                          igreja.horarioCulto!,
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (igreja.site != null && igreja.site!.isNotEmpty) ...[
                        _buildInfoRow(
                          context,
                          Icons.language_rounded,
                          'Website / Rede Social',
                          igreja.site!,
                          onTap: () => _abrirLink(igreja.site!),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Divider(
                          color: theme.colorScheme.outlineVariant
                              .withValues(alpha: 0.5)),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        context,
                        Icons.location_city,
                        'Cidade',
                        cidade,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        context,
                        Icons.location_on,
                        'Morada',
                        morada.isEmpty ? 'Morada indisponível' : morada,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (igreja.latitude != null &&
                              igreja.longitude != null)
                            _buildActionButton(
                              context,
                              icon: Icons.directions,
                              label: 'Rotas',
                              onTap: () {
                                final url =
                                    'https://www.google.com/maps/search/?api=1&query=${igreja.latitude},${igreja.longitude}';
                                _abrirLink(url);
                              },
                            ),
                          if (igreja.telefone != null &&
                              igreja.telefone!.isNotEmpty)
                            _buildActionButton(
                              context,
                              icon: Icons.phone,
                              label: 'Ligar',
                              onTap: () {
                                _abrirLink('tel:${igreja.telefone}');
                              },
                            ),
                          if (igreja.email != null && igreja.email!.isNotEmpty)
                            _buildActionButton(
                              context,
                              icon: Icons.email,
                              label: 'Email',
                              onTap: () {
                                _abrirLink('mailto:${igreja.email}');
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(error.toString(), textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String title, String value,
      {VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: theme.colorScheme.secondary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.45,
                      color: onTap != null ? theme.colorScheme.primary : null,
                      decoration: onTap != null ? TextDecoration.underline : null,
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

  Widget _buildActionButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filledTonal(
          onPressed: onTap,
          icon: Icon(icon),
          iconSize: 24,
          style: IconButton.styleFrom(
            minimumSize: const Size(52, 52),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
