import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class TMDBService {
  // ======================
  // BASE REQUEST
  // ======================
  Future<List<dynamic>> _getList(String endpoint) async {
    final url = Uri.parse('$tmdbBaseUrl$endpoint&api_key=$tmdbApiKey');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed request');
    }

    final data = json.decode(response.body);
    return data['results'] ?? [];
  }

  // ======================
  // DISCOVER (POPULAR / TOP RATED)
  // ======================
  Future<List<dynamic>> fetchDiscoverMovies({
    required String sortBy,
    int? genreId,
    int page = 1,
  }) async {
    String endpoint =
        '/discover/movie?'
        'sort_by=$sortBy'
        '&vote_count.gte=3000'
        '&page=$page';

    if (genreId != null) {
      endpoint += '&with_genres=$genreId';
    }

    return _getList('$endpoint&');
  }

  // ======================
  // 🔥 UPCOMING (ENDPOINT RESMI)
  // ======================
  Future<List<dynamic>> fetchUpcomingMovies({int page = 1}) async {
    return _getList(
      '/movie/upcoming?'
      'page=$page'
      '&region=US',
    );
  }

  // ======================
  // NOW PLAYING (ENDPOINT RESMI)
  // ======================
  Future<List<dynamic>> fetchNowPlayingMovies({int page = 1}) async {
    return _getList(
      '/movie/now_playing?'
      'page=$page'
      '&region=US',
    );
  }

  // ======================
  // SEARCH
  // ======================
  Future<List<dynamic>> searchMovies(String query) async {
    final encoded = Uri.encodeQueryComponent(query);
    return _getList('/search/movie?query=$encoded&');
  }

  // ======================
  // GENRES
  // ======================
  Future<List<dynamic>> fetchGenres() async {
    final url =
        Uri.parse('$tmdbBaseUrl/genre/movie/list?api_key=$tmdbApiKey');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load genres');
    }

    final data = json.decode(response.body);
    return data['genres'] ?? [];
  }

  // ======================
  // TRAILER
  // ======================
  Future<String?> fetchTrailer(int movieId) async {
    final url = Uri.parse(
      '$tmdbBaseUrl/movie/$movieId/videos?api_key=$tmdbApiKey',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body);
    final results = data['results'] ?? [];

    for (var video in results) {
      if (video['site'] == 'YouTube' &&
          video['type'] == 'Trailer') {
        return video['key'];
      }
    }
    return null;
  }
}
