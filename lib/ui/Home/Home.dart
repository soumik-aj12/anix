import 'package:anix/services/auth.dart';
import 'package:anix/ui/Home/Activity.dart';
import 'package:anix/ui/Home/CurrentlyWatching.dart';
import 'package:anix/ui/Home/Trending.dart';
import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = AuthService();
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected:
            (index) => setState(() {
              _selectedIndex = index;
            }),
        items: [
          FlashyTabBarItem(icon: Icon(Icons.home), title: Text('Home')),
          FlashyTabBarItem(icon: Icon(Icons.search), title: Text('Discover')),
          FlashyTabBarItem(icon: Icon(Icons.party_mode), title: Text('Anime')),
          FlashyTabBarItem(
            icon: Icon(Icons.settings),
            title: Text('My Profile'),
          ),
        ],
      ),
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
