import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final String uid;

  Database({required this.uid});
  final CollectionReference userCollection = FirebaseFirestore.instance
      .collection('users');

  Future<void> addUserData({
    required String username,
    required String email,
  }) async {
    try {
      await userCollection.doc(uid).set({
        'username': username,
        'email': email,
        'photoUrl': '',
        'bio': '',
        'createdAt': FieldValue.serverTimestamp(),
        'lastActive': FieldValue.serverTimestamp(),
        'isOnline': true,
      });
    } catch (e) {
      throw Exception('Failed to add user data: $e');
    }
  }

  Future<DocumentSnapshot> getUserData() async {
    try {
      return await userCollection.doc(uid).get();
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    try {
      final QuerySnapshot result =
          await userCollection
              .where('username', isEqualTo: username)
              .limit(1)
              .get();
      return result.docs.isEmpty;
    } catch (e) {
      throw Exception('Failed to check username availability: $e');
    }
  }
}
