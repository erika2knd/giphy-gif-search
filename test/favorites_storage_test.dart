import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:giphy_gif_search/features/gifs/data/models/gif_model.dart';
import 'package:giphy_gif_search/features/gifs/favorites/favorites_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FavoritesStorage', () {
    test('saves and loads favorites map', () async {
      SharedPreferences.setMockInitialValues({});

      final storage = FavoritesStorage();

      final gif1 = GifModel(
        id: '1',
        title: 'T1',
        username: 'u1',
        previewUrl: 'https://example.com/1.gif',
        originalUrl: 'https://example.com/1-original.gif',
      );

      final gif2 = GifModel(
        id: '2',
        title: 'T2',
        username: 'u2',
        previewUrl: 'https://example.com/2.gif',
        originalUrl: 'https://example.com/2-original.gif',
      );

      final mapToSave = {'1': gif1, '2': gif2};

      await storage.save(mapToSave);

      final loaded = await storage.load();

      expect(loaded.length, 2);
      expect(loaded['1']?.id, '1');
      expect(loaded['1']?.previewUrl, 'https://example.com/1.gif');
      expect(loaded['2']?.id, '2');
      expect(loaded['2']?.title, 'T2');
    });
  });
}
