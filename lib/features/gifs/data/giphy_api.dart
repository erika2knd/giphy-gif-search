import 'package:dio/dio.dart';

import '../../../core/constants/api_key.dart';

class GiphyApi {
  final Dio dio;
  GiphyApi(this.dio);

  static const _trendingPath = '/gifs/trending';
  static const _searchPath = '/gifs/search';

  Map<String, dynamic> _baseParams({required int limit, required int offset}) {
    if (giphyApiKey.trim().isEmpty) {
      throw StateError(
        'GIPHY API key is empty. Please provide it in core/constants/api_key.dart '
        'or via --dart-define (recommended).',
      );
    }

    return {'api_key': giphyApiKey, 'limit': limit, 'offset': offset};
  }

  Future<Map<String, dynamic>> trending({
    required int limit,
    required int offset,
  }) async {
    final res = await dio.get(
      _trendingPath,
      queryParameters: _baseParams(limit: limit, offset: offset),
    );

    final data = res.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return data.cast<String, dynamic>();

    throw DioException(
      requestOptions: res.requestOptions,
      type: DioExceptionType.badResponse,
      error: 'Unexpected response format from GIPHY trending endpoint',
    );
  }

  Future<Map<String, dynamic>> search({
    required String query,
    required int limit,
    required int offset,
  }) async {
    final q = query.trim();
    if (q.isEmpty) {
      return {
        'data': <dynamic>[],
        'pagination': {'total_count': 0, 'count': 0, 'offset': offset},
        'meta': {'status': 200, 'msg': 'Empty query', 'response_id': ''},
      };
    }

    final res = await dio.get(
      _searchPath,
      queryParameters: {
        ..._baseParams(limit: limit, offset: offset),
        'q': q,
      },
    );

    final data = res.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return data.cast<String, dynamic>();

    throw DioException(
      requestOptions: res.requestOptions,
      type: DioExceptionType.badResponse,
      error: 'Unexpected response format from GIPHY search endpoint',
    );
  }
}
