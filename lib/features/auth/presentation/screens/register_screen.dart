import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

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
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      setState(() => _isLoading = false);
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'As senhas não coincidem.';
      });
      return;
    }

    try {
      await ref.read(authProvider.notifier).signUpWithEmail(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
      if (mounted) context.pop();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = _parseError(e);
      });
    }
  }

  String _parseError(dynamic e) {
    final message = e.toString().toLowerCase();
    if (message.contains('email-already-in-use')) {
      return 'Este e-mail já está a ser utilizado.';
    }
    if (message.contains('weak-password')) {
      return 'A senha é muito fraca. Usa pelo menos 6 caracteres.';
    }
    if (message.contains('invalid-email')) {
      return 'O e-mail inserido é inválido.';
    }
    return 'Erro ao criar conta. Tenta novamente.';
  }

  InputDecoration _fieldDecoration(
    BuildContext context, {
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, size: 22),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: theme.colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  const Icon(Icons.person_add_outlined, size: 64, color: Colors.blue),
                  const SizedBox(height: 16),
                  Text(
                    'Junta-te à comunidade HPC+',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 32),
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: BorderRadius.circular(12)),
                      child: Text(_errorMessage!, style: TextStyle(color: theme.colorScheme.onErrorContainer)),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          enabled: !_isLoading,
                          decoration: _fieldDecoration(context, label: 'E-mail', hint: 'teu@email.com', icon: Icons.email_outlined),
                          validator: (v) => (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          enabled: !_isLoading,
                          decoration: _fieldDecoration(
                            context, 
                            label: 'Senha', 
                            hint: 'Mínimo 6 caracteres', 
                            icon: Icons.lock_outline,
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
                          decoration: _fieldDecoration(context, label: 'Confirmar Senha', hint: 'Repete a senha', icon: Icons.lock_reset),
                          validator: (v) => (v == null || v.isEmpty) ? 'Confirma a senha' : null,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _onRegister,
                            child: _isLoading 
                                ? const CircularProgressIndicator(strokeWidth: 2) 
                                : const Text('Criar Conta'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
