import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_layout.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    FocusScope.of(context).unfocus();

    try {
      await ref.read(authProvider.notifier).sendPasswordResetEmail(
            _emailController.text.trim(),
          );
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSuccess = true;
        });
      }
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
    if (message.contains('user-not-found')) {
      return 'Não encontramos nenhuma conta com este e-mail.';
    }
    if (message.contains('invalid-email')) {
      return 'O e-mail inserido é inválido.';
    }
    return 'Ocorreu um erro. Tenta novamente mais tarde.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AuthLayout(
      title: 'Recuperar Senha',
      subtitle: 'Enviaremos um link para o teu e-mail',
      showBackButton: true,
      child: _isSuccess 
        ? Column(
            children: [
              const Icon(Icons.mark_email_read_rounded, size: 64, color: Colors.green),
              const SizedBox(height: 24),
              Text(
                'E-mail enviado!',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Verifica a tua caixa de entrada e segue as instruções para criar uma nova senha.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () => context.pop(),
                  child: const Text('VOLTAR AO LOGIN'),
                ),
              ),
            ],
          )
        : Form(
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
                  textInputAction: TextInputAction.done,
                  decoration: AuthUIUtils.fieldDecoration(
                    context,
                    label: 'Teu E-mail',
                    hint: 'teu@email.com',
                    icon: Icons.email_outlined,
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Insere o teu e-mail' : null,
                  onFieldSubmitted: (_) => _onResetPassword(),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 56,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _onResetPassword,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('ENVIAR LINK'),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
