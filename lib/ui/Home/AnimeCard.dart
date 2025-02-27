import 'package:flutter/material.dart';

class AnimeCard extends StatelessWidget {
  final String image;
  final String title;
  final String episode;
  AnimeCard({required this.image, required this.title, this.episode = ""});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              image,
              height: 180,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(episode, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
