import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../domain/models/igreja.dart';

class IgrejaCard extends StatelessWidget {
  final Igreja igreja;
  final VoidCallback onTap;

  const IgrejaCard({
    super.key,
    required this.igreja,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final local =
        igreja.cidade.trim().isEmpty ? 'Localização via KUID' : igreja.cidade;
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem ou Placeholder
            Expanded(
              flex: 3,
              child: SizedBox(
                width: double.infinity,
                child: igreja.foto != null
                    ? CachedNetworkImage(
                        imageUrl: igreja.foto!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                            Icons.church,
                            size: 48,
                            color: Colors.grey),
                      )
                    : Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.church,
                            size: 48, color: Colors.grey),
                      ),
              ),
            ),
            // Detalhes
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      igreja.nome,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      local,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
