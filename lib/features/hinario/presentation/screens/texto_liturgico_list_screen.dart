import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/hinario_providers.dart';

class TextoLiturgicoListScreen extends ConsumerWidget {
  final String tipo;

  const TextoLiturgicoListScreen({super.key, required this.tipo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textosAsync = ref.watch(textosLiturgicosPorTipoProvider(tipo));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Textos Litúrgicos'),
      ),
      body: textosAsync.when(
        data: (textos) {
          if (textos.isEmpty) {
            return const Center(child: Text('Nenhum texto encontrado.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: textos.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final texto = textos[index];
              return ListTile(
                title: Text(texto.titulo),
                subtitle: texto.idioma != null ? Text(texto.idioma!.toUpperCase()) : null,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/hinario/txl/${texto.id}'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erro: $error')),
      ),
    );
  }
}
