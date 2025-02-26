import 'package:anix/services/auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('aniX', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          CircleAvatar(backgroundImage: NetworkImage(_auth.user!.photoURL!)),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBar(),
            const SizedBox(height: 20),
            SectionTitle(title: 'Continue Watching'),
            // AnimeList(),
            SectionTitle(title: 'Trending now'),
            // TrendingAnimeList(),
            SectionTitle(title: 'Activity Feed'),
            // ActivityFeed(),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  SectionTitle({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
