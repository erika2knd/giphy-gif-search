import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/gif_model.dart';
import '../../gifs_providers.dart';

class GifsState {
  final String query;
  final List<GifModel> items;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final bool hasMore;
  final Map<String, GifModel> favoritesById;

  const GifsState({
    required this.query,
    required this.items,
    required this.isLoading,
    required this.isLoadingMore,
    required this.error,
    required this.hasMore,
    required this.favoritesById,
  });

  factory GifsState.initial() => const GifsState(
    query: '',
    items: [],
    isLoading: false,
    isLoadingMore: false,
    error: null,
    hasMore: true,
    favoritesById: {},
  );

  GifsState copyWith({
    String? query,
    List<GifModel>? items,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool? hasMore,
    Map<String, GifModel>? favoritesById,
  }) {
    return GifsState(
      query: query ?? this.query,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      favoritesById: favoritesById ?? this.favoritesById,
    );
  }
}

final gifsControllerProvider = NotifierProvider<GifsController, GifsState>(
  GifsController.new,
);

class GifsController extends Notifier<GifsState> {
  static const int _limit = 25;

  Timer? _debounce;
  int _offset = 0;

  @override
  GifsState build() {
    _init();
    return GifsState.initial();
  }

  Future<void> _init() async {
    final storage = ref.read(favoritesStorageProvider);
    final favs = await storage.load();
    state = state.copyWith(favoritesById: favs);
    await loadInitial();
  }

  Future<void> loadInitial() async {
    _offset = 0;
    state = state.copyWith(
      isLoading: true,
      isLoadingMore: false,
      error: null,
      hasMore: true,
      items: [],
      query: state.query,
    );
    await _fetch(reset: true);
  }

  void onQueryChanged(String value) {
    final q = value.trim();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      setQuery(q);
    });
  }

  Future<void> setQuery(String query) async {
    _offset = 0;
    state = state.copyWith(
      query: query,
      isLoading: true,
      isLoadingMore: false,
      error: null,
      hasMore: true,
      items: [],
    );
    await _fetch(reset: true);
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true, error: null);
    await _fetch(reset: false);
  }

  Future<void> retry() async {
    if (state.items.isEmpty) {
      await loadInitial();
    } else {
      await _fetch(reset: false);
    }
  }

  Future<void> _fetch({required bool reset}) async {
    final repo = ref.read(gifsRepositoryProvider);

    try {
      final isSearch = state.query.isNotEmpty;

      final newItems = isSearch
          ? await repo.search(
              query: state.query,
              limit: _limit,
              offset: _offset,
            )
          : await repo.getTrending(limit: _limit, offset: _offset);

      _offset += newItems.length;

      final merged = reset ? newItems : [...state.items, ...newItems];

      state = state.copyWith(
        items: merged,
        hasMore: newItems.length == _limit,
        isLoading: false,
        isLoadingMore: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: 'Network error: $e',
      );
    }
  }

  bool isFavorite(GifModel gif) => state.favoritesById.containsKey(gif.id);

  Future<void> toggleFavorite(GifModel gif) async {
    final map = {...state.favoritesById};
    if (map.containsKey(gif.id)) {
      map.remove(gif.id);
    } else {
      map[gif.id] = gif;
    }
    state = state.copyWith(favoritesById: map);
    await ref.read(favoritesStorageProvider).save(map);
  }

  Future<void> removeFavorite(String id) async {
    final map = {...state.favoritesById}..remove(id);
    state = state.copyWith(favoritesById: map);
    await ref.read(favoritesStorageProvider).save(map);
  }
}
