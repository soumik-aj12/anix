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
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadAnimeDetails();
  }

  Future<void> _loadAnimeDetails() async {
    if (widget.id == null) {
      setState(() {
        error = "Anime ID is missing";
        isLoading = false;
      });
      return;
    }

    try {
      final data = await _animeService.fetchAnimeById(widget.id!);
      setState(() {
        detail = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Failed to load anime details";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : error != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(error!, style: TextStyle(color: Colors.red)),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          error = null;
                        });
                        _loadAnimeDetails();
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              )
              : detail == null
              ? Center(child: Text("No details available"))
              : _buildAnimeDetails(),
    );
  }

  Widget _buildAnimeDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      detail?['trailer']?['images']?['large_image_url'] ??
                          detail?['images']?['jpg']?['large_image_url'] ??
                          "",
                    ),
                    fit: BoxFit.cover,
                    onError: (error, stackTrace) {},
                  ),
                ),
              ),
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 10,
                child: SafeArea(
                  child: IconButton(
                    onPressed: () => context.go('/discover'),
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.black.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          Transform.translate(
            offset: Offset(0, -40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      detail?['images']?['jpg']?['large_image_url'] ?? "",
                      width: 140,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 140,
                          height: 200,
                          color: Colors.grey[200],
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16),

                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Added to watchlist")),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: Text("Add to WatchList"),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                            size: 30,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Added to favorites")),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail?['title'] ?? "Unknown Title",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (detail?['title_japanese'] != null) ...[
                  SizedBox(height: 4),
                  Text(
                    detail!['title_japanese'],
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
                SizedBox(height: 16),

                Row(
                  children: [
                    _buildStatChip(
                      Icons.star,
                      Colors.amber,
                      "${detail?['score'] ?? 'N/A'}",
                    ),
                    SizedBox(width: 12),
                    _buildStatChip(
                      Icons.view_list,
                      Colors.blue,
                      "${detail?['episodes'] ?? 'N/A'} ep",
                    ),
                    SizedBox(width: 12),
                    _buildStatChip(
                      Icons.calendar_today,
                      Colors.green,
                      "${detail?['year'] ?? 'N/A'}",
                    ),
                  ],
                ),
                SizedBox(height: 16),

                Text(
                  "Synopsis",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  detail?['synopsis'] ?? "No synopsis available.",
                  style: TextStyle(fontSize: 15, height: 1.5),
                ),
                SizedBox(height: 16),

                Text(
                  "Information",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                _buildInfoRow("Type", detail?['type'] ?? "N/A"),
                _buildInfoRow("Status", detail?['status'] ?? "N/A"),
                _buildInfoRow("Aired", detail?['aired']?['string'] ?? "N/A"),
                _buildInfoRow("Rating", detail?['rating'] ?? "N/A"),
                _buildInfoRow(
                  "Genres",
                  (detail?['genres'] as List<dynamic>?)
                          ?.map((genre) => genre['name'])
                          .join(", ") ??
                      "N/A",
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, Color color, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[900])),
          ),
        ],
      ),
    );
  }
}
