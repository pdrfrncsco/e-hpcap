import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/update_checker.dart';
import 'update_dialog.dart';

/// Envolve qualquer ecrã e verifica atualizações uma vez por sessão.
/// Coloca este widget no topo da árvore (ex: em torno do [MainNavigationScreen]).
class UpdateCheckerWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const UpdateCheckerWrapper({super.key, required this.child});

  @override
  ConsumerState<UpdateCheckerWrapper> createState() => _UpdateCheckerWrapperState();
}

class _UpdateCheckerWrapperState extends ConsumerState<UpdateCheckerWrapper> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    // Agendar verificação após o primeiro frame (não bloquear o arranque)
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkUpdate());
  }

  Future<void> _checkUpdate() async {
    // Não verificar em debug para não atrapalhar o desenvolvimento
    if (kDebugMode) return;
    // Só mostrar uma vez por sessão
    if (_dialogShown) return;

    try {
      final result = await ref.read(updateCheckerProvider).checkForUpdate();

      if (!result.hasUpdate || result.info == null) return;
      if (!mounted) return;

      _dialogShown = true;

      await showDialog<void>(
        context: context,
        // Se for update obrigatório, não fecha ao tocar fora
        barrierDismissible: !result.info!.forceUpdate,
        builder: (_) => UpdateDialog(
          info: result.info!,
          canDismiss: !result.info!.forceUpdate,
        ),
      );
    } catch (_) {
      // Falha silenciosa
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
