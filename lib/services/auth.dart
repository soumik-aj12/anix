import 'package:anix/services/customToast.dart';
import 'package:anix/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService {
  final _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signOut({required BuildContext context}) async {
    if (_auth.currentUser != null) {
      final db = Database(uid: _auth.currentUser!.uid);
      await db.updateUserStatus(isOnline: false);
    }
    await _auth.signOut();
    context.go("/login");
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

  Future<bool> signInWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      print(password);
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (_auth.currentUser != null) {
        final db = Database(uid: _auth.currentUser!.uid);
        await db.updateUserStatus(isOnline: true);
      }

      ToastService.showToast(
        context,
        message: 'Login successful!',
        isError: false,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many failed login attempts. Try again later';
          break;
        default:
          errorMessage = 'Failed to sign in';
      }

      ToastService.showToast(context, message: errorMessage, isError: true);

      return false;
    } catch (e) {
      ToastService.showToast(
        context,
        message: 'An unexpected error occurred',
        isError: true,
      );

      return false;
    }
  }

  signInWithGoogle({required BuildContext context}) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        signInOption:
            SignInOption.standard, // Forces the account picker to show
        forceCodeForRefreshToken: true,
      );

      // When signing in
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      if (_auth.currentUser != null) {
        final db = Database(uid: _auth.currentUser!.uid);
        await db.updateUserStatus(isOnline: true);
      }
      ToastService.showToast(
        context,
        message: 'Login successful!',
        isError: false,
      );
      return userCredential;
    } catch (e) {
      ToastService.showToast(
        context,
        message: 'An unexpected error occurred',
        isError: true,
      );

      return null;
    }
  }
}
