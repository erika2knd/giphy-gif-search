import 'package:dio/dio.dart';

import 'giphy_api.dart';
import 'models/gif_model.dart';

class GifsRepository {
  final GiphyApi api;
  GifsRepository(this.api);

  Future<List<GifModel>> getTrending({
    required int limit,
    required int offset,
  }) async {
    try {
      final data = await api.trending(limit: limit, offset: offset);
      return _parseGifList(data);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<GifModel>> search({
    required String query,
    required int limit,
    required int offset,
  }) async {
    try {
      final data = await api.search(query: query, limit: limit, offset: offset);
      return _parseGifList(data);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  List<GifModel> _parseGifList(Map<String, dynamic> data) {
    final raw = data['data'];
    if (raw is! List) return const <GifModel>[];

    return raw
        .whereType<Map>()
        .map((e) => GifModel.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Exception _mapDioError(DioException e) {
    final status = e.response?.statusCode;

    if (status == 401) {
      return Exception('Unauthorized (401). Check your GIPHY API key.');
    }
    if (status == 429) {
      return Exception('Rate limit exceeded (429). Please try again later.');
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return Exception('Request timed out. Please try again.');
    }
    if (e.type == DioExceptionType.connectionError) {
      return Exception('No internet connection.');
    }

    return Exception('Network error: ${e.message}');
  }
}
