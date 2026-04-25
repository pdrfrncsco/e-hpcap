import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/local_storage/database_service.dart';
import '../../data/repositories/hinario_repository.dart';
import '../../domain/models/hino.dart';
import '../../domain/models/tema.dart';
import '../../../auth/data/auth_interceptor.dart';

// --- Services ---
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(interceptors: [AuthInterceptor()]);
});
final databaseServiceProvider = Provider<DatabaseService>((ref) => DatabaseService());

// --- Repository ---
final hinarioRepositoryProvider = Provider<HinarioRepository>((ref) {
  final dio = ref.watch(apiClientProvider).client;
  final db = ref.watch(databaseServiceProvider);
  return HinarioRepository(dio, db);
});

// --- Filtros State ---
final secaoSelecionadaProvider = StateProvider<String>(
  (ref) => 'pt',
); // Por defeito: Português
final temaSelecionadoProvider = StateProvider<String?>((ref) => null);
final searchQueryProvider = StateProvider<String>((ref) => '');

// --- Providers de Dados ---

// Busca temas
final temasProvider = FutureProvider<List<Tema>>((ref) async {
  final repository = ref.watch(hinarioRepositoryProvider);
  return repository.getTemas();
});

// Busca Hinos baseado nos filtros (Secão e Tema)
final hinosListProvider = FutureProvider<List<Hino>>((ref) async {
  final repository = ref.watch(hinarioRepositoryProvider);
  final secao = ref.watch(secaoSelecionadaProvider);
  final temaSlug = ref.watch(temaSelecionadoProvider);

  return repository.getHinos(secao: secao, temaSlug: temaSlug);
});

// Busca Hinos por termo de pesquisa
final hinoSearchResultsProvider = FutureProvider<List<Hino>>((ref) async {
  final repository = ref.watch(hinarioRepositoryProvider);
  final secao = ref.watch(secaoSelecionadaProvider);
  final query = ref.watch(searchQueryProvider);

  if (query.isEmpty) {
    return [];
  }

  return repository.buscarHinos(query, secao: secao);
});

// Provider para o detalhe do hino (Family provider aceita um ID)
final hinoDetalheProvider = FutureProvider.family<Hino, int>((ref, id) async {
  final repository = ref.watch(hinarioRepositoryProvider);
  return repository.getHinoDetalhe(id);
});
