import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/gif_model.dart';

class FavoritesStorage {
  static const _key = 'favorites_v2';

  Future<Map<String, GifModel>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_key) ?? [];

    final map = <String, GifModel>{};
    for (final s in stored) {
      try {
        final obj = jsonDecode(s);
        if (obj is Map<String, dynamic>) {
          final gif = GifModel.fromFavoriteJson(obj);
          if (gif.id.isNotEmpty) map[gif.id] = gif;
        }
      } catch (_) {}
    }
    return map;
  }

  Future<void> save(Map<String, GifModel> favoritesById) async {
    final prefs = await SharedPreferences.getInstance();
    final list = favoritesById.values
        .map((g) => jsonEncode(g.toFavoriteJson()))
        .toList();
    await prefs.setStringList(_key, list);
  }
}
