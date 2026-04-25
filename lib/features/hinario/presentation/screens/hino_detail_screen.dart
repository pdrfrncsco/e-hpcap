import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/hinario_providers.dart';
import '../providers/reading_preferences_provider.dart';
import '../../domain/models/estrofe.dart';
import '../../domain/models/hino.dart';

class HinoDetailScreen extends ConsumerStatefulWidget {
  final int hinoId;

  const HinoDetailScreen({super.key, required this.hinoId});

  @override
  ConsumerState<HinoDetailScreen> createState() => _HinoDetailScreenState();
}

class _HinoDetailScreenState extends ConsumerState<HinoDetailScreen> {
  late PageController _pageController;
  List<Hino> _hinosLista = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showFontSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const _FontSettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hinosAsyncValue = ref.watch(hinosListProvider);
    final theme = Theme.of(context);
    final prefs = ref.watch(readingPreferencesProvider);

    return hinosAsyncValue.when(
      data: (hinos) {
        _hinosLista = hinos;
        // Encontrar o índice inicial baseado no hinoId
        final initialIndex = hinos.indexWhere((h) => h.id == widget.hinoId);
        
        // Se não encontrar na lista atual (ex: link direto), mostra apenas um
        if (initialIndex == -1) {
          return _buildSingleHinoScaffold(widget.hinoId);
        }

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.text_fields_rounded),
                onPressed: () => _showFontSettings(context),
              ),
            ],
          ),
          body: PageView.builder(
            controller: PageController(initialPage: initialIndex),
            itemCount: hinos.length,
            itemBuilder: (context, index) {
              return _HinoContent(hino: hinos[index], prefs: prefs);
            },
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, __) => _buildSingleHinoScaffold(widget.hinoId),
    );
  }

  Widget _buildSingleHinoScaffold(int id) {
    final hinoAsyncValue = ref.watch(hinoDetalheProvider(id));
    final prefs = ref.watch(readingPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields_rounded),
            onPressed: () => _showFontSettings(context),
          ),
        ],
      ),
      body: hinoAsyncValue.when(
        data: (hino) => _HinoContent(hino: hino, prefs: prefs),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text('Erro: $e')),
      ),
    );
  }
}

class _HinoContent extends StatelessWidget {
  final Hino hino;
  final ReadingPreferences prefs;

  const _HinoContent({required this.hino, required this.prefs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final estrofes = hino.estrofes ?? [];
    
    // Base de tamanhos de fonte escaláveis
    final baseTitleSize = 24.0 * prefs.fontSizeMultiplier;
    final baseBodySize = 18.0 * prefs.fontSizeMultiplier;
    final baseLabelSize = 13.0 * prefs.fontSizeMultiplier;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho do Hino
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${hino.numero}.',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: baseTitleSize * 1.1,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  hino.titulo.toUpperCase(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    fontSize: baseTitleSize * 0.9,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          if (hino.letraDe != null || hino.musicaDe != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hino.letraDe?.isNotEmpty ?? false)
                    Text('Letra: ${hino.letraDe}', 
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: baseLabelSize)),
                  if (hino.musicaDe?.isNotEmpty ?? false)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('Música: ${hino.musicaDe}', 
                        style: theme.textTheme.bodyMedium?.copyWith(fontSize: baseLabelSize)),
                    ),
                ],
              ),
            ),
            
          const SizedBox(height: 32),
          
          if (estrofes.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    Icon(Icons.notes_rounded, size: 48, color: theme.colorScheme.outline),
                    const SizedBox(height: 16),
                    const Text('Letra não disponível offline.'),
                  ],
                ),
              ),
            )
          else
            ...estrofes.map((e) => _buildEstrofe(context, e, baseBodySize, baseLabelSize)),
            
          const SizedBox(height: 40),
          const Center(child: Icon(Icons.church_rounded, size: 24, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildEstrofe(BuildContext context, Estrofe estrofe, double bodySize, double labelSize) {
    final theme = Theme.of(context);
    final isRefrao = estrofe.tipo == 'refrao';

    final marcador = switch (estrofe.tipo) {
      'refrao' => 'CORO',
      'ponte' => 'PONTE',
      _ => '${estrofe.numeroNoTipo ?? estrofe.ordem}.',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: isRefrao ? const EdgeInsets.fromLTRB(16, 16, 16, 16) : null,
      decoration: isRefrao ? BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: theme.colorScheme.primary, width: 4),
        ),
      ) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isRefrao)
            SizedBox(
              width: 32,
              child: Text(
                marcador,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: labelSize,
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isRefrao)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      marcador,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        fontSize: labelSize * 0.9,
                      ),
                    ),
                  ),
                ...estrofe.versos.map((verso) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    verso,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                      fontSize: bodySize,
                      fontWeight: isRefrao ? FontWeight.w500 : FontWeight.w400,
                      fontStyle: isRefrao ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FontSettingsSheet extends ConsumerWidget {
  const _FontSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(readingPreferencesProvider);
    final theme = Theme.of(context);

    return Container(
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
    );
  }
}
