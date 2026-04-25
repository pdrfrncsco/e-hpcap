import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/repositories/igrejas_repository.dart';
import '../../domain/models/igreja.dart';
import '../../domain/models/conferencia.dart';
import '../../domain/models/distrito.dart';

// --- API & Repository ---
import '../../../hinario/presentation/providers/hinario_providers.dart'; // Onde está o apiClientProvider

final igrejasRepositoryProvider = Provider<IgrejasRepository>((ref) {
  final dio = ref.watch(apiClientProvider).client;
  return IgrejasRepository(dio);
});

final myIgrejaProvider = FutureProvider<Igreja?>((ref) async {
  final repository = ref.watch(igrejasRepositoryProvider);
  return repository.getMyIgreja();
});

// --- Localização Provider ---
final localizacaoProvider = FutureProvider<Position?>((ref) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return null;

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return null;
  }
  if (permission == LocationPermission.deniedForever) return null;

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.medium,
  );
});

// --- Filtros State ---
final conferenciaSelecionadaProvider = StateProvider<String?>((ref) => null);
final distritoSelecionadoProvider = StateProvider<int?>((ref) => null);
final searchIgrejaQueryProvider = StateProvider<String>((ref) => '');

// Enum para o toggle view
enum IgrejasViewType { mapa, grade, lista }
final igrejasViewTypeProvider = StateProvider<IgrejasViewType>((ref) => IgrejasViewType.lista);

// --- Providers de Dados ---

// Busca conferências
final conferenciasProvider = FutureProvider<List<Conferencia>>((ref) async {
  final repository = ref.watch(igrejasRepositoryProvider);
  return repository.getConferencias();
});

// Busca distritos (depende da conferência selecionada, mas pode vir tudo)
final distritosProvider = FutureProvider<List<Distrito>>((ref) async {
  final repository = ref.watch(igrejasRepositoryProvider);
  // Se tivéssemos o ID da conferência no State, poderíamos filtrar aqui,
  // mas o StateProvider atual guarda o código ('CAOA'), não o ID.
  return repository.getDistritos(); 
});

// Busca Igrejas baseado nos filtros
final igrejasListProvider = FutureProvider<List<Igreja>>((ref) async {
  final repository = ref.watch(igrejasRepositoryProvider);
  final confCodigo = ref.watch(conferenciaSelecionadaProvider);
  final distritoId = ref.watch(distritoSelecionadoProvider);
  final query = ref.watch(searchIgrejaQueryProvider);

  return repository.getIgrejas(
    conferenciaCodigo: confCodigo,
    distritoId: distritoId,
    query: query,
  );
});

// Igrejas próximas
final igrejasProximasProvider = FutureProvider<List<Igreja>>((ref) async {
  final repository = ref.watch(igrejasRepositoryProvider);
  final locAsync = ref.watch(localizacaoProvider);
  
  return locAsync.when(
    data: (position) {
      if (position == null) return [];
      return repository.getIgrejasProximas(position.latitude, position.longitude);
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Provider para o detalhe da igreja
final igrejaDetalheProvider = FutureProvider.family<Igreja, int>((ref, id) async {
  final repository = ref.watch(igrejasRepositoryProvider);
  return repository.getIgrejaDetalhe(id);
});
