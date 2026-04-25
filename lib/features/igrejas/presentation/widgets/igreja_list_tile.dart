import 'package:flutter/material.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              theme.colorScheme.primaryContainer.withValues(alpha: 0.75),
          child: Icon(
            Icons.church,
            color: theme.colorScheme.onPrimaryContainer,
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
                  '${igreja.distanciaKm} km',
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
