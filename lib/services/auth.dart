import 'package:anix/services/customToast.dart';
import 'package:anix/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService {
  final _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> createUserWithEmailAndPassword({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final databaseService = Database(uid: ''); // temporary uid
      final isUsernameAvailable = await databaseService.isUsernameAvailable(
        username,
      );

      if (!isUsernameAvailable) {
        ToastService.showToast(
          context,
          message: 'Username is already taken',
          isError: true,
        );
        return false;
      }

      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        final db = Database(uid: userCredential.user!.uid);
        await db.addUserData(username: username, email: email);

        ToastService.showToast(
          context,
          message: 'Account created successfully!',
          isError: false,
        );
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw AuthException('The password provided is too weak');
        case 'email-already-in-use':
          throw AuthException('An account already exists for that email');
        case 'invalid-email':
          throw AuthException('The email address is not valid');
        default:
          throw AuthException('An error occurred during registration');
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException('An unexpected error occurred');
    }
  }

  signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
