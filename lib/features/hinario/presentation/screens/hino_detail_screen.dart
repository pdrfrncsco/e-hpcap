import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/analytics_service.dart';
import '../providers/hinario_providers.dart';
import '../providers/reading_preferences_provider.dart';
import '../../domain/models/estrofe.dart';
import '../../domain/models/hino.dart';
import '../widgets/font_settings_sheet.dart';

class HinoDetailScreen extends ConsumerStatefulWidget {
  final int hinoId;

  const HinoDetailScreen({super.key, required this.hinoId});

  @override
  ConsumerState<HinoDetailScreen> createState() => _HinoDetailScreenState();
}

class _HinoDetailScreenState extends ConsumerState<HinoDetailScreen> {
  late PageController _pageController;
  Hino? _hinoAtual; // Para manter o título do AppBar sincronizado

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
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const FontSettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hinosAsyncValue = ref.watch(hinosListProvider);
    final theme = Theme.of(context);
    final prefs = ref.watch(readingPreferencesProvider);

    return hinosAsyncValue.when(
      data: (hinos) {
        final initialIndex = hinos.indexWhere((h) => h.id == widget.hinoId);
        
        if (initialIndex == -1) {
          return _buildSingleHinoLoader(widget.hinoId);
        }

        // Se ainda não definimos o hino atual (primeira carga)
        if (_hinoAtual == null) {
          _hinoAtual = hinos[initialIndex];
          // Log inicial
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_hinoAtual != null) {
              AnalyticsService.logHinoViewed(
                hinoId: _hinoAtual!.id,
                hinoTitle: _hinoAtual!.titulo,
              );
            }
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                '${_hinoAtual?.numero}. ${_hinoAtual?.titulo.toUpperCase()}',
                key: ValueKey(_hinoAtual?.id),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            centerTitle: true,
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
            onPageChanged: (index) {
              setState(() {
                _hinoAtual = hinos[index];
              });
              if (_hinoAtual != null) {
                AnalyticsService.logHinoViewed(
                  hinoId: _hinoAtual!.id,
                  hinoTitle: _hinoAtual!.titulo,
                );
              }
            },
            itemBuilder: (context, index) {
              return _HinoPageItem(hinoId: hinos[index].id);
            },
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, __) => _buildSingleHinoLoader(widget.hinoId),
    );
  }

  Widget _buildSingleHinoLoader(int id) {
    // Para links diretos onde não há uma lista de contexto
    final hinoAsync = ref.watch(hinoDetalheProvider(id));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: hinoAsync.maybeWhen(
          data: (h) => Text('${h.numero}. ${h.titulo.toUpperCase()}'),
          orElse: () => const Text('Hino'),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields_rounded),
            onPressed: () => _showFontSettings(context),
          ),
        ],
      ),
      body: _HinoPageItem(hinoId: id),
    );
  }
}

class _HinoPageItem extends ConsumerWidget {
  final int hinoId;

  const _HinoPageItem({required this.hinoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hinoAsync = ref.watch(hinoDetalheProvider(hinoId));
    final prefs = ref.watch(readingPreferencesProvider);

    return hinoAsync.when(
      data: (hino) => _HinoContent(hino: hino, prefs: prefs),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Não foi possível carregar a letra deste hino.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(hinoDetalheProvider(hinoId)),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
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
    
    final baseBodySize = 18.0 * prefs.fontSizeMultiplier;
    final baseLabelSize = 13.0 * prefs.fontSizeMultiplier;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informações de autoria (Metadados)
          if (hino.letraDe != null || hino.musicaDe != null)
            Container(
              margin: const EdgeInsets.only(bottom: 32),
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
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: baseLabelSize, fontWeight: FontWeight.w600)),
                  if (hino.musicaDe?.isNotEmpty ?? false)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('Música: ${hino.musicaDe}', 
                        style: theme.textTheme.bodyMedium?.copyWith(fontSize: baseLabelSize, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
            ),
          
          if (estrofes.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    Icon(Icons.notes_rounded, size: 48, color: theme.colorScheme.outline),
                    const SizedBox(height: 16),
                    const Text('Letra não disponível para leitura offline.'),
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
