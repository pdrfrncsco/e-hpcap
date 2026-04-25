import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/data/repositories/upgrade_repository.dart';
import '../../../igrejas/presentation/providers/igrejas_providers.dart';
import '../../../igrejas/presentation/screens/edit_my_igreja_screen.dart'; // Para o KuidMaskFormatter

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showUpgradeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _UpgradeDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => ref.read(authProvider.notifier).signOut(),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Não autenticado'));
          }

          final profileLabel = user.role == 'igreja' ? 'Igreja' : 'Membro';

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(currentUserProvider),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 42,
                          backgroundColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
                          child: Icon(
                            user.role == 'igreja' ? Icons.church_rounded : Icons.person_rounded,
                            size: 40,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          user.username,
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                        if (user.email.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            user.email,
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            profileLabel,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SectionCard(
                    title: 'Conta',
                    children: [
                      _ProfileItem(
                        icon: Icons.edit_rounded,
                        title: 'Editar perfil',
                        subtitle: 'Atualize os dados da conta',
                        onTap: () {},
                      ),
                      if (user.role == 'igreja')
                        _ProfileItem(
                          icon: Icons.church_rounded,
                          title: 'Gerir igreja',
                          subtitle: 'Dados e horários da igreja',
                          onTap: () => context.push('/igrejas/minha-igreja'),
                        ),
                      if (user.role == 'membro')
                        _ProfileItem(
                          icon: Icons.verified_user_rounded,
                          title: 'Representar uma Igreja',
                          subtitle: 'Solicitar acesso de gestor',
                          onTap: () => _showUpgradeDialog(context, ref),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Preferências',
                    children: [
                      _ProfileItem(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notificações',
                        subtitle: 'Alertas e lembretes',
                        onTap: () {},
                      ),
                      _ProfileItem(
                        icon: Icons.lock_outline_rounded,
                        title: 'Privacidade',
                        subtitle: 'Permissões e segurança',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => ref.read(authProvider.notifier).signOut(),
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Sair da conta'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                        side: BorderSide(color: theme.colorScheme.error.withValues(alpha: 0.4)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text('Erro: $e')),
      ),
    );
  }
}

class _UpgradeDialog extends ConsumerStatefulWidget {
  const _UpgradeDialog();

  @override
  ConsumerState<_UpgradeDialog> createState() => _UpgradeDialogState();
}

class _UpgradeDialogState extends ConsumerState<_UpgradeDialog> {
  final _kuidController = TextEditingController();
  final _telefoneController = TextEditingController();
  bool _isValidando = false;
  bool _isKuidValido = false;
  String? _kuidMensagem;
  String _kuidSignupUrl = 'https://kuid.me';
  Timer? _debounce;

  @override
  void dispose() {
    _kuidController.dispose();
    _telefoneController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onKuidChanged(String value) {
    _debounce?.cancel();
    final kuid = value.trim();

    if (kuid.isEmpty || kuid.length < 15) {
      setState(() {
        _isKuidValido = false;
        _kuidMensagem = null;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 600), () {
      _validarKuid(kuid);
    });
  }

  Future<void> _validarKuid(String kuid) async {
    setState(() {
      _isValidando = true;
      _kuidMensagem = null;
    });

    try {
      final result = await ref.read(igrejasRepositoryProvider).validarKuid(kuid);
      if (!mounted) return;

      if (result['valid'] == true) {
        setState(() {
          _isKuidValido = true;
          _kuidMensagem = "Igreja encontrada: ${result['morada']}";
          _kuidSignupUrl = result['signup_url'] ?? _kuidSignupUrl;
        });
      } else {
        setState(() {
          _isKuidValido = false;
          _kuidMensagem = result['message'] ?? "KUID inválido.";
          _kuidSignupUrl = result['signup_url'] ?? _kuidSignupUrl;
        });
      }
    } catch (e) {
      setState(() {
        _isKuidValido = false;
        _kuidMensagem = "Erro ao validar KUID.";
      });
    } finally {
      if (mounted) setState(() => _isValidando = false);
    }
  }

  Future<void> _abrirLinkKuid() async {
    final uri = Uri.parse(_kuidSignupUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Representar Igreja'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Introduz os dados para solicitar a gestão da igreja.'),
            const SizedBox(height: 20),
            TextField(
              controller: _kuidController,
              onChanged: _onKuidChanged,
              inputFormatters: [KuidMaskFormatter()],
              decoration: InputDecoration(
                labelText: 'KUID da Igreja',
                hintText: 'Ex: AO-LUA-ING-ZOLL',
                border: const OutlineInputBorder(),
                suffixIcon: _isValidando 
                    ? const SizedBox(width: 20, height: 20, child: Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(strokeWidth: 2)))
                    : _isKuidValido ? const Icon(Icons.check_circle, color: Colors.green) : null,
              ),
            ),
            if (_kuidMensagem != null) ...[
              const SizedBox(height: 8),
              Text(
                _kuidMensagem!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _isKuidValido ? Colors.green : theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: _telefoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Telefone do Representante',
                hintText: 'Ex: 923 000 000',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: _abrirLinkKuid,
              child: Text(
                'Se ainda não tens o KUID da tua Igreja, clica aqui para obter.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: (!_isKuidValido || _isValidando) ? null : () async {
            final telefone = _telefoneController.text.trim();
            if (telefone.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Insere o teu número de telefone.')),
              );
              return;
            }

            try {
              await ref.read(upgradeRepositoryProvider).requestUpgrade(
                _kuidController.text.trim(),
                telefone,
              );
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Solicitação enviada! Aguarda aprovação do administrador.')),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString()), backgroundColor: theme.colorScheme.error),
                );
              }
            }
          },
          child: const Text('Solicitar'),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
            child: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileItem({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.32),
        child: Icon(icon, color: theme.colorScheme.primary),
      ),
      title: Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
