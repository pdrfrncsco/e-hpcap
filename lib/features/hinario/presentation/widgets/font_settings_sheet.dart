import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/reading_preferences_provider.dart';

class FontSettingsSheet extends ConsumerWidget {
  const FontSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(readingPreferencesProvider);
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Definições de Leitura',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.format_size_rounded),
                const SizedBox(width: 16),
                const Text('Tamanho da Letra'),
                const Spacer(),
                Text(
                  '${(prefs.fontSizeMultiplier * 100).toInt()}%',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Slider(
              value: prefs.fontSizeMultiplier,
              min: 0.8,
              max: 2.0,
              divisions: 6,
              onChanged: (val) {
                ref.read(readingPreferencesProvider.notifier).setFontSizeMultiplier(val);
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Manter ecrã ligado'),
              subtitle: const Text('Evita que o telemóvel bloqueie durante a leitura'),
              value: prefs.keepScreenOn,
              onChanged: (val) {
                ref.read(readingPreferencesProvider.notifier).setKeepScreenOn(val);
              },
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
