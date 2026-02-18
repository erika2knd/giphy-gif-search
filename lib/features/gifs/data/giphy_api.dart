import 'package:dio/dio.dart';
import '../../../core/constants/api_key.dart';

class GiphyApi {
  final Dio dio;
  GiphyApi(this.dio);

  Future<Map<String, dynamic>> trending({
    required int limit,
    required int offset,
  }) async {
    final res = await dio.get(
      'https://api.giphy.com/v1/gifs/trending',
      queryParameters: {
        'api_key': giphyApiKey,
        'limit': limit,
        'offset': offset,
      },
    );
    return (res.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> search({
    required String query,
    required int limit,
    required int offset,
  }) async {
    final res = await dio.get(
      'https://api.giphy.com/v1/gifs/search',
      queryParameters: {
        'api_key': giphyApiKey,
        'q': query,
        'limit': limit,
        'offset': offset,
      },
    );
    return (res.data as Map).cast<String, dynamic>();
  }
}
