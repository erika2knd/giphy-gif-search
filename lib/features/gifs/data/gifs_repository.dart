import 'giphy_api.dart';
import 'models/gif_model.dart';

class GifsRepository {
  final GiphyApi api;
  GifsRepository(this.api);

  Future<List<GifModel>> getTrending({
    required int limit,
    required int offset,
  }) async {
    final data = await api.trending(limit: limit, offset: offset);
    final list = (data['data'] as List).cast<Map>();
    return list
        .map((e) => GifModel.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<List<GifModel>> search({
    required String query,
    required int limit,
    required int offset,
  }) async {
    final data = await api.search(query: query, limit: limit, offset: offset);
    final list = (data['data'] as List).cast<Map>();
    return list
        .map((e) => GifModel.fromJson(e.cast<String, dynamic>()))
        .toList();
  }
}
