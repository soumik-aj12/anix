import 'package:anix/services/anime.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnimeDetailScreen extends StatefulWidget {
  final String? id;
  AnimeDetailScreen({required this.id});
  @override
  _AnimeDetailScreenState createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
  animeService _animeService = animeService();
  Map<String, dynamic>? detail;
  @override
  void initState() {
    super.initState();
    _animeService.fetchAnimeById(widget.id!).then((data) {
      setState(() {
        detail = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text('Anime Detail')),
          body:
              detail == null
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.network(
                          detail!['trailer']['images']['large_image_url'],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            detail!['title'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            detail!['synopsis'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go('/home');
              },
              child: Text('Back to Home'),
            ),
          ),
        ),
      ],
    );
  }
}
