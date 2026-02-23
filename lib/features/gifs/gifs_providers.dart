import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:giphy_gif_search/core/network/dio_providers.dart';
import 'package:giphy_gif_search/features/gifs/data/giphy_api.dart';
import 'package:giphy_gif_search/features/gifs/data/gifs_repository.dart';
import 'package:giphy_gif_search/features/gifs/favorites/favorites_storage.dart';

final giphyApiProvider = Provider<GiphyApi>((ref) {
  final dio = ref.watch(dioProvider);
  return GiphyApi(dio);
});

final gifsRepositoryProvider = Provider<GifsRepository>((ref) {
  final api = ref.watch(giphyApiProvider);
  return GifsRepository(api);
});

final favoritesStorageProvider = Provider<FavoritesStorage>((ref) {
  return FavoritesStorage();
});
