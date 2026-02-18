import 'package:flutter_test/flutter_test.dart';
import 'package:giphy_gif_search/features/gifs/data/models/gif_model.dart';

void main() {
  group('GifModel', () {
    test('fromJson parses required fields safely', () {
      final json = {
        'id': 'abc123',
        'title': 'Funny cat',
        'username': 'john',
        'images': {
          'fixed_height': {'url': 'https://example.com/preview.gif'},
          'original': {'url': 'https://example.com/original.gif'},
        },
      };

      final gif = GifModel.fromJson(json);

      expect(gif.id, 'abc123');
      expect(gif.title, 'Funny cat');
      expect(gif.username, 'john');
      expect(gif.previewUrl, 'https://example.com/preview.gif');
      expect(gif.originalUrl, 'https://example.com/original.gif');
    });

    test('fromJson does not crash when images are missing', () {
      final json = {'id': 'id1', 'title': null, 'username': null};

      final gif = GifModel.fromJson(json);

      expect(gif.id, 'id1');
      expect(gif.title, '');
      expect(gif.username, '');
      expect(gif.previewUrl, '');
      expect(gif.originalUrl, '');
    });
  });
}
