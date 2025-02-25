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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home'),
            Text(_auth.user!.email!),
            ElevatedButton(
              onPressed: () => _auth.signOut(context: context),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
