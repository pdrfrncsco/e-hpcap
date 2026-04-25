import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/hinario_providers.dart';
import '../../domain/models/estrofe.dart';

class HinoDetailScreen extends ConsumerWidget {
  final int hinoId;

  const HinoDetailScreen({super.key, required this.hinoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hinoDetalheAsyncValue = ref.watch(hinoDetalheProvider(hinoId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          hinoDetalheAsyncValue.maybeWhen(
            data: (hino) => '${hino.numero}. ${hino.titulo.toUpperCase()}',
            orElse: () => 'Hino',
          ),
        ),
        centerTitle: true,
      ),
      body: hinoDetalheAsyncValue.when(
        data: (hino) {
          final estrofes = hino.estrofes ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hino.titulo,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                if (hino.letraDe != null || hino.musicaDe != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hino.letraDe != null &&
                            hino.letraDe!.trim().isNotEmpty)
                          Text(
                            'Letra: ${hino.letraDe}',
                            style: theme.textTheme.bodyMedium,
                          ),
                        if (hino.musicaDe != null &&
                            hino.musicaDe!.trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              'Música: ${hino.musicaDe}',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 28),
                const Divider(),
                const SizedBox(height: 20),
                if (estrofes.isEmpty)
                  Center(
                    child: Text(
                      'Letra não disponível.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                else
                  ...estrofes.map((estrofe) => _buildEstrofe(context, estrofe)),
              ],
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEstrofe(BuildContext context, Estrofe estrofe) {
    final theme = Theme.of(context);
    final isRefrao = estrofe.tipo == 'refrao';

    final marcador = switch (estrofe.tipo) {
      'refrao' => 'Refrão',
      'ponte' => 'Ponte',
      _ => '${estrofe.numeroNoTipo ?? estrofe.ordem}ª',
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 42,
            child: Text(
              marcador,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isRefrao
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: estrofe.versos.map((verso) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    verso,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
