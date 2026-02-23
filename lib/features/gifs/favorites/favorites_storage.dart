import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/gif_model.dart';

class FavoritesStorage {
  static const _key = 'favorites_v2';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<Map<String, GifModel>> load() async {
    final prefs = await _getPrefs();
    final stored = prefs.getStringList(_key) ?? [];

    final map = <String, GifModel>{};

    for (final s in stored) {
      try {
        final obj = jsonDecode(s) as Map<String, dynamic>;
        final gif = GifModel.fromFavoriteJson(obj);

        if (gif.id.isNotEmpty) {
          map[gif.id] = gif;
        }
      } catch (_) {}
    }

    return map;
  }

  Future<void> save(Map<String, GifModel> favoritesById) async {
    final prefs = await _getPrefs();

    final list = favoritesById.values.toList()
      ..sort((a, b) => a.id.compareTo(b.id));

    final encoded = list.map((g) => jsonEncode(g.toFavoriteJson())).toList();

    await prefs.setStringList(_key, encoded);
  }
}
