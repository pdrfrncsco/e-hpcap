import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/repositories/eventos_repository.dart';
import '../../domain/models/evento_categoria.dart';
import '../../domain/models/evento_publicacao.dart';

final eventosRepositoryProvider = Provider<EventosRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return EventosRepository(dio);
});

final eventoCategoriaSelecionadaProvider = StateProvider<String?>((ref) => null);
final eventoSearchQueryProvider = StateProvider<String>((ref) => '');

final eventoCategoriasProvider = FutureProvider<List<EventoCategoria>>((ref) async {
  final repository = ref.watch(eventosRepositoryProvider);
  return repository.getCategorias();
});

final eventosDestaqueProvider = FutureProvider<List<EventoPublicacao>>((ref) async {
  final repository = ref.watch(eventosRepositoryProvider);
  return repository.getPublicacoes(destaque: true);
});

final eventosFeedProvider = FutureProvider<List<EventoPublicacao>>((ref) async {
  final repository = ref.watch(eventosRepositoryProvider);
  final categoriaSlug = ref.watch(eventoCategoriaSelecionadaProvider);
  final query = ref.watch(eventoSearchQueryProvider);
  return repository.getPublicacoes(
    categoriaSlug: categoriaSlug,
    query: query,
  );
});

final eventoDetalheProvider =
    FutureProvider.family<EventoPublicacao, int>((ref, id) async {
  final repository = ref.watch(eventosRepositoryProvider);
  return repository.getPublicacaoDetalhe(id);
});

final eventosRelacionadosProvider =
    FutureProvider.family<List<EventoPublicacao>, EventoPublicacao>((ref, evento) async {
  final repository = ref.watch(eventosRepositoryProvider);
  final items = await repository.getPublicacoes(
    categoriaSlug: evento.categoria.slug,
  );
  return items.where((item) => item.id != evento.id).take(6).toList();
});

class EventoInteracaoState {
  final Set<int> likedIds;
  final Set<int> favoritedIds;

  const EventoInteracaoState({
    this.likedIds = const {},
    this.favoritedIds = const {},
  });

  EventoInteracaoState copyWith({
    Set<int>? likedIds,
    Set<int>? favoritedIds,
  }) {
    return EventoInteracaoState(
      likedIds: likedIds ?? this.likedIds,
      favoritedIds: favoritedIds ?? this.favoritedIds,
    );
  }
}

class EventoInteracaoNotifier extends StateNotifier<EventoInteracaoState> {
  EventoInteracaoNotifier() : super(const EventoInteracaoState());

  void toggleLike(int id) {
    final liked = Set<int>.from(state.likedIds);
    if (!liked.add(id)) {
      liked.remove(id);
    }
    state = state.copyWith(likedIds: liked);
  }

  void toggleFavorite(int id) {
    final favorites = Set<int>.from(state.favoritedIds);
    if (!favorites.add(id)) {
      favorites.remove(id);
    }
    state = state.copyWith(favoritedIds: favorites);
  }
}

final eventoInteracaoProvider =
    StateNotifierProvider<EventoInteracaoNotifier, EventoInteracaoState>(
  (ref) => EventoInteracaoNotifier(),
);
