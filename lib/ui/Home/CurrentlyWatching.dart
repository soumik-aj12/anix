import 'package:anix/ui/Home/AnimeCard.dart';
import 'package:flutter/material.dart';

class CurrentlyWatchingAnimeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          AnimeCard(
            image: 'https://cdn.myanimelist.net/images/anime/10/77957l.jpg',
            title: 'Erased',
            episode: 'Episode 8 of 13',
          ),
          AnimeCard(
            image: 'https://cdn.myanimelist.net/images/anime/1141/142503l.jpg',
            title: 'Naruto',
            episode: 'Episode 222 of 370',
          ),
        ],
      ),
    );
  }
}
