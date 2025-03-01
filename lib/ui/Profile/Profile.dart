import 'package:anix/services/auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _auth.user!.displayName!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(_auth.user!.email!),
            ElevatedButton(
              onPressed: () => _auth.signOut(context: context),
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
