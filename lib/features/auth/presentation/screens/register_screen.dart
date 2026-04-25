import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_layout.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'As senhas não coincidem.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    FocusScope.of(context).unfocus();

    try {
      await ref.read(authProvider.notifier).signUpWithEmail(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = _parseError(e);
        });
      }
    }
  }

  String _parseError(dynamic e) {
    final message = e.toString().toLowerCase();
    if (message.contains('email-already-in-use')) {
      return 'Este e-mail já está a ser utilizado.';
    }
    if (message.contains('weak-password')) {
      return 'A senha é muito fraca (mín. 6 caracteres).';
    }
    if (message.contains('invalid-email')) {
      return 'O e-mail inserido é inválido.';
    }
    return 'Erro ao criar conta. Tenta novamente.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AuthLayout(
      title: 'Criar Conta',
      subtitle: 'Junta-te à comunidade HPC+',
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_errorMessage != null) ...[
              AuthUIUtils.buildErrorBanner(context, _errorMessage!),
              const SizedBox(height: 20),
            ],
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              enabled: !_isLoading,
              textInputAction: TextInputAction.next,
              decoration: AuthUIUtils.fieldDecoration(
                context,
                label: 'E-mail',
                hint: 'teu@email.com',
                icon: Icons.email_outlined,
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              enabled: !_isLoading,
              textInputAction: TextInputAction.next,
              decoration: AuthUIUtils.fieldDecoration(
                context,
                label: 'Senha',
                hint: 'Mínimo 6 caracteres',
                icon: Icons.lock_outline_rounded,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: (v) => (v != null && v.length < 6) ? 'Mínimo 6 caracteres' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              enabled: !_isLoading,
              textInputAction: TextInputAction.done,
              decoration: AuthUIUtils.fieldDecoration(
                context,
                label: 'Confirmar Senha',
                hint: 'Repete a tua senha',
                icon: Icons.lock_reset_rounded,
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Confirma a tua senha' : null,
              onFieldSubmitted: (_) => _onRegister(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: _isLoading ? null : _onRegister,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('CRIAR CONTA', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Já tens uma conta?', style: theme.textTheme.bodyMedium),
                TextButton(
                  onPressed: _isLoading ? null : () => context.pop(),
                  child: const Text('Entra aqui', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
