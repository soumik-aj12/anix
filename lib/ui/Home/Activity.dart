import 'package:anix/services/auth.dart';
import 'package:flutter/material.dart';

class ActivityFeed extends StatelessWidget {
  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ActivityCard(
            username: 'sam',
            time: '12:00',
            activity: 'AIZEN VS. YHWACH!!!',
            avatar: _auth.user!.photoURL!,
          ),
          ActivityCard(
            username: 'sam',
            time: '13:00',
            activity: 'Claymore is peakkk!!!',
            avatar: _auth.user!.photoURL!,
          ),
        ],
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String username;
  final String time;
  final String activity;
  final String avatar;
  ActivityCard({
    required this.username,
    required this.time,
    required this.activity,
    required this.avatar,
  });
  @override
  Widget build(BuildContext) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(avatar)),
        title: Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(height: 4),
            Text(activity),
          ],
        ),
      ),
    );
  }
}
