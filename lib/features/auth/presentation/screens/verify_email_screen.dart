import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_layout.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _isResending = false;
  bool _isChecking = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Agendar uma verificação automática a cada 5 segundos
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _checkVerification(isManual: false));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkVerification({bool isManual = true}) async {
    if (isManual) setState(() => _isChecking = true);
    
    try {
      await ref.read(authProvider.notifier).reloadUser();
      final user = ref.read(authProvider).value;
      
      if (user?.emailVerified ?? false) {
        _timer?.cancel();
        if (mounted) context.go('/hinario');
      } else if (isManual && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('O e-mail ainda não foi verificado. Verifica a tua caixa de entrada.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (isManual && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao verificar: $e')),
        );
      }
    } finally {
      if (isManual && mounted) setState(() => _isChecking = false);
    }
  }

  void _onResendEmail() async {
    setState(() => _isResending = true);
    try {
      await ref.read(authProvider.notifier).resendVerificationEmail();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail de verificação reenviado.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;
    final theme = Theme.of(context);

    return AuthLayout(
      title: 'Verifica o teu e-mail',
      subtitle: 'Enviámos um link para ${user?.email ?? 'o teu e-mail'}.',
      showBackButton: true,
      onBack: () => ref.read(authProvider.notifier).signOut(),
      child: Column(
        children: [
          const Icon(
            Icons.mark_email_read_outlined,
            size: 80,
            color: Colors.blue,
          ),
          const SizedBox(height: 24),
          Text(
            'Por favor, clica no link enviado para confirmares a tua conta. '
            'Se não encontrares, verifica a pasta de Spam.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: _isChecking ? null : () => _checkVerification(isManual: true),
              icon: _isChecking 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.refresh_rounded),
              label: Text(_isChecking ? 'A VERIFICAR...' : 'JÁ VERIFIQUEI'),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _isResending ? null : _onResendEmail,
            child: _isResending
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Reenviar e-mail de confirmação'),
          ),
          const SizedBox(height: 24),
          const Divider(),
          TextButton(
            onPressed: () => ref.read(authProvider.notifier).signOut(),
            child: const Text('Usar outra conta / Sair', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
