import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/hinario_providers.dart';

class FiltrosHinario extends ConsumerWidget {
  const FiltrosHinario({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final secaoAtual = ref.watch(secaoSelecionadaProvider);

    return SizedBox(
      height: 60, // Levemente mais compacto
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          _buildSecaoChip(context, ref, 'Português', 'pt', secaoAtual),
          const SizedBox(width: 8),
          _buildSecaoChip(context, ref, 'Kimbundu', 'kim', secaoAtual),
          const SizedBox(width: 8),
          _buildSecaoChip(context, ref, 'Umbundu', 'umb', secaoAtual),
          const SizedBox(width: 8),
          _buildSecaoChip(context, ref, 'Kikongo', 'kik', secaoAtual),
          const SizedBox(width: 8),
          _buildSecaoChip(context, ref, 'Textos Litúrgicos', 'txl', secaoAtual),
        ],
      ),
    );
  }

  Widget _buildSecaoChip(
    BuildContext context,
    WidgetRef ref,
    String label,
    String valor,
    String secaoAtual,
  ) {
    final isSelected = secaoAtual == valor;
    final theme = Theme.of(context);

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          ref.read(secaoSelecionadaProvider.notifier).state = valor;
        }
      },
      showCheckmark: false,
      backgroundColor: theme.colorScheme.surface,
      selectedColor: theme.colorScheme.primaryContainer,
      side: BorderSide(
        color: isSelected 
            ? Colors.transparent 
            : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
      ),
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: isSelected 
            ? theme.colorScheme.onPrimaryContainer 
            : theme.colorScheme.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
    );
  }
}