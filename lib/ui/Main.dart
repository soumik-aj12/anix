import 'package:anix/services/auth.dart';
import 'package:anix/ui/Home/Home.dart';
import 'package:anix/ui/Profile/Profile.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _auth = AuthService();
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get user initials for fallback avatar
    String initials = '';
    if (_auth.user != null && _auth.user!.email != null) {
      initials = _auth.user!.email![0].toUpperCase();
      // If displayName is available, use that instead
      if (_auth.user!.displayName != null &&
          _auth.user!.displayName!.isNotEmpty) {
        final nameParts = _auth.user!.displayName!.split(' ');
        if (nameParts.length > 1) {
          initials = '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
        } else if (nameParts.isNotEmpty) {
          initials = nameParts[0][0].toUpperCase();
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('aniX', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildAvatar(initials),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: [
          // Home Page
          HomeScreen(),
          // Users Page
          Center(child: Text('Messages Page')),
          // Messages Page
          Center(child: Text('Messages Page')),
          // Settings Page
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) {
          setState(() => _selectedIndex = index);
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Home'),
            activeColor: Colors.red,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.people),
            title: Text('Users'),
            activeColor: Colors.purpleAccent,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.message),
            title: Text('Messages'),
            activeColor: Colors.pink,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String initials) {
    if (_auth.user?.photoURL != null) {
      return CircleAvatar(backgroundImage: NetworkImage(_auth.user!.photoURL!));
    } else {
      return CircleAvatar(
        backgroundColor: Colors.teal,
        child: Text(
          initials,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
  }
}
