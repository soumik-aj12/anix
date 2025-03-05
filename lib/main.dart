import 'package:anix/firebase_options.dart';
import 'package:anix/ui/Authentication/Login.dart';
import 'package:anix/ui/Authentication/Register.dart';
import 'package:anix/ui/Discover/AnimeDetail.dart';
import 'package:anix/ui/Intro.dart';
import 'package:anix/ui/Main.dart';
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
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => IntroScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => RegisterScreen()),
    GoRoute(path: '/home', builder: (context, state) => MainScreen()),
    GoRoute(
      path: '/discover/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return AnimeDetailScreen(id: id);
      },
    ),
  ],
);
