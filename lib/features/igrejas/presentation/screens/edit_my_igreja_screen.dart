import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/models/igreja.dart';
import '../providers/igrejas_providers.dart';

class KuidMaskFormatter extends TextInputFormatter {
  static const List<int> _groups = [2, 3, 3, 4];

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw =
        newValue.text.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();
    var index = 0;
    final parts = <String>[];
    for (final size in _groups) {
      if (index >= raw.length) break;
      final end = (index + size < raw.length) ? index + size : raw.length;
      parts.add(raw.substring(index, end));
      index = end;
    }
    final masked = parts.join('-');
    return TextEditingValue(
      text: masked,
      selection: TextSelection.collapsed(offset: masked.length),
    );
  }
}

class EditMyIgrejaScreen extends ConsumerStatefulWidget {
  const EditMyIgrejaScreen({super.key});

  @override
  ConsumerState<EditMyIgrejaScreen> createState() => _EditMyIgrejaScreenState();
}

class _EditMyIgrejaScreenState extends ConsumerState<EditMyIgrejaScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _pastorController = TextEditingController();
  final _kuidController = TextEditingController();
  final _moradaController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _horarioController = TextEditingController();

  int? _selectedDistritoId;
  bool _isLoading = false;
  bool _isValidandoKuid = false;
  bool _kuidValido = true;
  String? _kuidMensagem;
  String _kuidSignupUrl =
      'https://play.google.com/store/apps/details?id=com.ndeascloud.kuid';
  Timer? _kuidDebounce;
  Igreja? _currentIgreja;

  bool _isKuidCompleto(String kuid) => kuid.length == 15;

  @override
  void initState() {
    super.initState();
    _loadIgreja();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _pastorController.dispose();
    _kuidController.dispose();
    _moradaController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _horarioController.dispose();
    _kuidDebounce?.cancel();
    super.dispose();
  }

  Future<void> _loadIgreja() async {
    setState(() => _isLoading = true);
    final igreja = await ref.read(igrejasRepositoryProvider).getMyIgreja();
    if (igreja != null && mounted) {
      setState(() {
        _currentIgreja = igreja;
        _nomeController.text = igreja.nome;
        _pastorController.text = igreja.pastor;
        _kuidController.text = (igreja.kuid ?? '').toUpperCase();
        _moradaController.text = igreja.morada ?? '';
        _latitudeController.text = igreja.latitude?.toString() ?? '';
        _longitudeController.text = igreja.longitude?.toString() ?? '';
        _telefoneController.text = igreja.telefone ?? '';
        _emailController.text = igreja.email ?? '';
        _horarioController.text = igreja.horarioCulto ?? '';
        _selectedDistritoId = igreja.distrito?.id;
      });
      final kuid = (igreja.kuid ?? '').toUpperCase().trim();
      if (kuid.isNotEmpty) {
        _validarKuid(kuid);
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _abrirLinkKuid() async {
    final uri = Uri.parse(_kuidSignupUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _onKuidChanged(String value) {
    _kuidDebounce?.cancel();
    final kuid = value.trim();

    if (kuid.isEmpty || !_isKuidCompleto(kuid)) {
      setState(() {
        _kuidValido = true;
        _kuidMensagem = null;
        _moradaController.clear();
        _latitudeController.clear();
        _longitudeController.clear();
      });
      return;
    }

    _kuidDebounce = Timer(const Duration(milliseconds: 600), () {
      _validarKuid(kuid);
    });
  }

  Future<void> _validarKuid(String kuid) async {
    setState(() {
      _isValidandoKuid = true;
      _kuidMensagem = null;
    });

    final result = await ref.read(igrejasRepositoryProvider).validarKuid(kuid);
    if (!mounted || _kuidController.text.trim() != kuid) return;

    final valid = result['valid'] == true;
    if (valid) {
      setState(() {
        _kuidValido = true;
        _kuidMensagem = null;
        _moradaController.text = (result['morada'] ?? '').toString();
        _latitudeController.text = result['latitude']?.toString() ?? '';
        _longitudeController.text = result['longitude']?.toString() ?? '';
      });
    } else {
      setState(() {
        _kuidValido = false;
        _kuidMensagem = (result['message'] ?? 'KUID inválido.').toString();
        _kuidSignupUrl = (result['signup_url'] ??
                'https://play.google.com/store/apps/details?id=com.ndeascloud.kuid')
            .toString();
        _moradaController.clear();
        _latitudeController.clear();
        _longitudeController.clear();
      });
    }

    if (mounted) {
      setState(() => _isValidandoKuid = false);
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final kuidAtual = _kuidController.text.trim();

    if (kuidAtual.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O código KUID é obrigatório.')),
      );
      return;
    }

    if (_isValidandoKuid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aguarde a validação do KUID...')),
      );
      return;
    }

    if (!_isKuidCompleto(kuidAtual)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('KUID incompleto. Use o formato AO-LUA-ING-ZOLL.'),
        ),
      );
      return;
    }

    if (!_kuidValido) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('KUID inválido. Corrija antes de salvar.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final data = {
      'nome': _nomeController.text.trim(),
      'pastor': _pastorController.text.trim(),
      'kuid': kuidAtual,
      'telefone': _telefoneController.text.trim(),
      'email': _emailController.text.trim(),
      'horario_culto': _horarioController.text.trim(),
      'distrito_id': _selectedDistritoId,
    };

    try {
      if (_currentIgreja != null) {
        await ref
            .read(igrejasRepositoryProvider)
            .updateIgreja(_currentIgreja!.id, data);
      } else {
        await ref
            .read(igrejasRepositoryProvider)
            .createMyIgreja(data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados actualizados com sucesso!')),
        );
        ref.invalidate(myIgrejaProvider);
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  InputDecoration _decoration({
    required String label,
    String? hint,
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon == null ? null : Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    final distritosAsync = ref.watch(distritosProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIgreja == null
              ? 'Configurar Minha Igreja'
              : 'Gerir Minha Igreja',
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(28),
                        border:
                            Border.all(color: theme.colorScheme.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detalhes da Congregação',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Mantenha os dados públicos da igreja claros e actualizados.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _nomeController,
                            decoration: _decoration(
                              label: 'Nome da Igreja',
                              icon: Icons.church_rounded,
                            ),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Obrigatório' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _pastorController,
                            decoration: _decoration(
                              label: 'Pastor Responsável',
                              icon: Icons.person_rounded,
                            ),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Obrigatório' : null,
                          ),
                          const SizedBox(height: 16),
                          distritosAsync.when(
                            data: (distritos) => DropdownButtonFormField<int>(
                              initialValue: _selectedDistritoId,
                              decoration: _decoration(
                                label: 'Distrito Eclesiástico',
                                icon: Icons.map_outlined,
                              ),
                              items: distritos
                                  .map(
                                    (d) => DropdownMenuItem<int>(
                                      value: d.id,
                                      child: Text(d.nome),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (id) =>
                                  setState(() => _selectedDistritoId = id),
                              validator: (v) =>
                                  v == null ? 'Obrigatório' : null,
                            ),
                            loading: () => const LinearProgressIndicator(),
                            error: (e, __) =>
                                Text('Erro ao carregar distritos: $e'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(28),
                        border:
                            Border.all(color: theme.colorScheme.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Localização e Contacto',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.45),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              'Ao validar o código KUID, a morada e coordenadas são exibidas no Mapa.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _kuidController,
                            onChanged: _onKuidChanged,
                            inputFormatters: [KuidMaskFormatter()],
                            decoration: _decoration(
                              label: 'KUID (Obrigatório)',
                              hint: 'Ex: AO-LUA-ING-ZOLL',
                              icon: Icons.key_rounded,
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Obrigatório';
                              }
                              if (!_isKuidCompleto(v.trim())) {
                                return 'KUID incompleto';
                              }
                              if (!_kuidValido) {
                                return _kuidMensagem ?? 'KUID inválido';
                              }
                              return null;
                            },
                          ),
                          if (_isValidandoKuid) ...[
                            const SizedBox(height: 10),
                            const LinearProgressIndicator(),
                          ],
                          if (!_kuidValido) ...[
                            const SizedBox(height: 10),
                            Text(
                              _kuidMensagem ?? 'KUID inválido.',
                              style: TextStyle(color: theme.colorScheme.error),
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: _abrirLinkKuid,
                              child: Text(
                                'Se ainda não tens um KUID, clica aqui para obter.',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _moradaController,
                            readOnly: true,
                            maxLines: 2,
                            decoration: _decoration(label: 'Morada (via KUID)'),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _telefoneController,
                            decoration: _decoration(
                              label: 'Telefone',
                              icon: Icons.phone_outlined,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            decoration: _decoration(
                              label: 'E-mail da Igreja',
                              icon: Icons.email_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(28),
                        border:
                            Border.all(color: theme.colorScheme.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cultos e Actividades',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _horarioController,
                            maxLines: 4,
                            decoration: _decoration(
                              label: 'Horários dos Cultos',
                              hint: 'Ex: Domingo às 10h\nQuarta-feira às 18h',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _onSave,
                        child: const Text(
                          'Salvar alterações',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
