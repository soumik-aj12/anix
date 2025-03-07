import 'package:anix/firebase_options.dart';
import 'package:anix/services/auth.dart';
import 'package:anix/ui/Authentication/Login.dart';
import 'package:anix/ui/Authentication/Register.dart';
import 'package:anix/ui/Discover/AnimeDetail.dart';
import 'package:anix/ui/Discover/Discover.dart';
import 'package:anix/ui/Intro.dart';
import 'package:anix/ui/Main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AuthWrapper());
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the app is still checking authentication state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // If user is authenticated
        if (snapshot.hasData) {
          return MaterialApp.router(
            routerConfig: _authenticatedRouter,
            debugShowCheckedModeBanner: false,
          );
        }

        // If authentication failed with error
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Authentication Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        // If user is not authenticated
        return MaterialApp.router(
          routerConfig: _unauthenticatedRouter,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

// Router for authenticated users
final GoRouter _authenticatedRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/home', builder: (context, state) => MainScreen()),
    GoRoute(path: '/discover', builder: (context, state) => DiscoverScreen()),
    GoRoute(
      path: '/discover/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return AnimeDetailScreen(id: id);
      },
    ),
  ],
);

// Router for unauthenticated users
final GoRouter _unauthenticatedRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => IntroScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => RegisterScreen()),
  ],
);
