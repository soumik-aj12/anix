import 'dart:convert';

import 'package:http/http.dart' as http;

// ignore: camel_case_types
class animeService {
  Future<List<dynamic>> fetchTrendingAnime() async {
    final url = 'https://api.jikan.moe/v4/top/anime?filter=airing';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        throw Exception(
          'Failed to fetch trending anime. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Map<String, dynamic>?> fetchAnimeById(String id) async {
    try {
      final url = 'https://api.jikan.moe/v4/anime/$id';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception(
          'Failed to fetch anime. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
