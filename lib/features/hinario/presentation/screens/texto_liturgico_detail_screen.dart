import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../providers/hinario_providers.dart';
import '../providers/reading_preferences_provider.dart';
import '../../domain/models/texto_liturgico.dart';
import '../widgets/font_settings_sheet.dart';

class TextoLiturgicoDetailScreen extends ConsumerStatefulWidget {
  final int textoId;

  const TextoLiturgicoDetailScreen({super.key, required this.textoId});

  @override
  ConsumerState<TextoLiturgicoDetailScreen> createState() => _TextoLiturgicoDetailScreenState();
}

class _TextoLiturgicoDetailScreenState extends ConsumerState<TextoLiturgicoDetailScreen> {
  late PageController _pageController;
  List<TextoLiturgico>? _allTextos;
  int _currentIndex = 0;

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
    final textosAsync = ref.watch(textosLiturgicosProvider);
    final theme = Theme.of(context);
    final prefs = ref.watch(readingPreferencesProvider);

    return textosAsync.when(
      data: (textos) {
        if (_allTextos == null) {
          // Filtrar textos do mesmo tipo para o PageView
          final target = textos.firstWhere((t) => t.id == widget.textoId);
          _allTextos = textos.where((t) => t.tipo == target.tipo).toList();
          _currentIndex = _allTextos!.indexWhere((t) => t.id == widget.textoId);
          _pageController = PageController(initialPage: _currentIndex);
        }

        final baseBodySize = 18.0 * prefs.fontSizeMultiplier;
        final baseTitleSize = 28.0 * prefs.fontSizeMultiplier;

        return Scaffold(
          appBar: AppBar(
            title: Text(_allTextos![_currentIndex].tipoDisplay),
            centerTitle: true,
            actions: [
               IconButton(
                icon: const Icon(Icons.text_fields_rounded),
                onPressed: () => _showFontSettings(context),
              ),
            ],
          ),
          body: PageView.builder(
            controller: _pageController,
            itemCount: _allTextos!.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final texto = _allTextos![index];
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      texto.titulo,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        fontSize: baseTitleSize,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (texto.idioma != null)
                      Text(
                        'Idioma: ${texto.idioma!.toUpperCase()}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    const Divider(height: 32),
                    MarkdownBody(
                      data: texto.conteudo,
                      styleSheet: MarkdownStyleSheet(
                        p: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: baseBodySize,
                          height: 1.6,
                        ),
                        strong: const TextStyle(fontWeight: FontWeight.bold),
                        em: const TextStyle(fontStyle: FontStyle.italic),
                        h1: theme.textTheme.headlineMedium?.copyWith(fontSize: baseTitleSize * 0.9, fontWeight: FontWeight.bold),
                        h2: theme.textTheme.titleLarge?.copyWith(fontSize: baseBodySize * 1.2, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          bottomNavigationBar: _allTextos!.length > 1
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_allTextos!.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _currentIndex
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primary.withValues(alpha: 0.2),
                        ),
                      );
                    }),
                  ),
                )
              : null,
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(body: Center(child: Text('Erro: $error'))),
    );
  }
}
