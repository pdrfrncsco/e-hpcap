import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/models/igreja.dart';

class IgrejaListTile extends StatelessWidget {
  final Igreja igreja;
  final VoidCallback onTap;

  const IgrejaListTile({
    super.key,
    required this.igreja,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final local =
        igreja.cidade.trim().isEmpty ? 'Localização via KUID' : igreja.cidade;
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: Hero(
          tag: 'igreja_foto_${igreja.id}',
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: igreja.foto != null
                ? CachedNetworkImage(
                    imageUrl: igreja.foto!,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Icon(
                      Icons.church,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  )
                : Icon(
                    Icons.church,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
          ),
        ),
        title: Text(
          igreja.nome,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('$local • ${igreja.distritoNome ?? ""}'),
        trailing: igreja.distanciaKm != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer
                      .withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${igreja.distanciaKm!.toStringAsFixed(1)} km',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              )
            : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
