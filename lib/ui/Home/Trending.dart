import 'package:anix/services/anime.dart';
import 'package:anix/services/customToast.dart';
import 'package:anix/ui/Home/AnimeCard.dart';
import 'package:flutter/material.dart';

class Trending extends StatefulWidget {
  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  final _animeService =
      animeService(); // Use AnimeService if you rename the class
  late Future<List<dynamic>> _trendingAnimeFuture;

  @override
  void initState() {
    super.initState();
    _trendingAnimeFuture = _animeService.fetchTrendingAnime();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: FutureBuilder<List<dynamic>>(
        future: _trendingAnimeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            ToastService.showToast(
              context,
              message: snapshot.error.toString(),
              isError: true,
            );
            return Center(child: Text("Error loading anime"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No trending anime found!"));
          }

          List<dynamic> data = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            itemBuilder: (context, index) {
              var anime = data[index];
              String title =
                  anime['title_english'] ?? anime['title'] ?? "Unknown Title";
              String imageUrl =
                  anime['images']?["jpg"]?["large_image_url"] ?? "";
              return AnimeCard(image: imageUrl, title: title);
            },
          );
        },
      ),
    );
  }
}
