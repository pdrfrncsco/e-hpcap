import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/hinario_providers.dart';
import '../../domain/models/texto_liturgico.dart';

class TxlListWidget extends ConsumerWidget {
  const TxlListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textosAsync = ref.watch(textosLiturgicosProvider);
    final theme = Theme.of(context);

    return textosAsync.when(
      data: (textos) {
        if (textos.isEmpty) {
          return const Center(child: Text('Nenhum texto litúrgico encontrado.'));
        }

        // Agrupar por tipo para exibir os cards de categorias
        final tipos = <String, List<TextoLiturgico>>{};
        for (final t in textos) {
          tipos.putIfAbsent(t.tipo, () => []).add(t);
        }

        final tiposList = tipos.entries.toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tiposList.length,
          itemBuilder: (context, index) {
            final entry = tiposList[index];
            final tipo = entry.key;
            final itens = entry.value;
            final display = itens.first.tipoDisplay;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(display),
                subtitle: Text('${itens.length} ${itens.length == 1 ? 'Leitura' : 'Leituras'}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Se houver apenas um item, vai direto para o detalhe
                  if (itens.length == 1) {
                    context.go('/hinario/txl/${itens.first.id}');
                  } else {
                    // Senão, vai para a lista de itens desse tipo
                    context.go('/hinario/txl/tipo/$tipo');
                  }
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Erro: $error')),
    );
  }
}
