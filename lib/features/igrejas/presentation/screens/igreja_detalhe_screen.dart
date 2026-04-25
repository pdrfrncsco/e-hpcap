import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/igrejas_providers.dart';

class IgrejaDetalheScreen extends ConsumerWidget {
  final int igrejaId;

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhe da Igreja'),
      ),
      body: asyncValue.when(
        data: (igreja) {
          final cidade = igreja.cidade.trim();
          final provincia = (igreja.provincia ?? '').trim();
          final morada = (igreja.morada ?? '').trim();
          final localizacaoTexto = [
            if (morada.isNotEmpty) morada,
            if (cidade.isNotEmpty || provincia.isNotEmpty)
              [cidade, provincia].where((e) => e.isNotEmpty).join(' - '),
          ].join('\n').trim();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Image
                if (igreja.foto != null)
                  SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: CachedNetworkImage(
                      imageUrl: igreja.foto!,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: 200,
                    color: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.church,
                      size: 80,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),

                Padding(
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
                            const SizedBox(height: 8),
                            Text(
                              '${igreja.distrito?.nome ?? "Sem distrito"} • ${igreja.distrito?.conferencia?.codigo ?? ""}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
                      Divider(
                          color: theme.colorScheme.outlineVariant
                              .withValues(alpha: 0.5)),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        context,
                        Icons.location_on,
                        'Morada',
                        localizacaoTexto.isEmpty
                            ? 'Localização disponível via KUID'
                            : localizacaoTexto,
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
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String title, String value) {
    final theme = Theme.of(context);
    return Row(
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
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
              ),
            ],
          ),
        ),
      ],
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
