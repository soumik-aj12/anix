import 'package:anix/ui/Home/Activity.dart';
import 'package:anix/ui/Home/CurrentlyWatching.dart';
import 'package:anix/ui/Home/Trending.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SearchBar(),
            // const SizedBox(height: 20),
            SectionTitle(title: 'Continue Watching'),
            CurrentlyWatchingAnimeList(),
            SectionTitle(title: 'Trending now'),
            Trending(),
            SectionTitle(title: 'Activity Feed'),
            ActivityFeed(),
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
