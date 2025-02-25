import 'package:anix/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  bool isLoading = false;
  bool isGoogleLoading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void handleLogin() async {
    setState(() {
      isLoading = true;
    });

    final success = await _auth.signInWithEmailAndPassword(
      context: context,
      email: email.text.trim(),
      password: password.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      // Navigate to home screen or dashboard
      context.go('/home');
    }
    // If not successful, the toast message will show the error
  }

  Future<void> handleGoogleSignIn() async {
    setState(() {
      isGoogleLoading = true;
    });

    try {
      final userCredential = await _auth.signInWithGoogle(context: context);

      if (userCredential != null) {
        context.go('/home');
      }
    } catch (e) {
      print('Google sign-in error: $e');
    } finally {
      setState(() {
        isGoogleLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome back!",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[100],
                  ),
                  child: TextField(
                    controller: email,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[100],
                  ),
                  child: TextField(
                    controller: password,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                    ),
                    obscureText: true,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.teal[600],
                  ),
                  child: Center(
                    child: TextButton(
                      onPressed: isLoading ? null : handleLogin,
                      child:
                          isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                child: ElevatedButton(
                  onPressed: isGoogleLoading ? null : handleGoogleSignIn,
                  child:
                      isGoogleLoading
                          ? SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('Sign In with Google'),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    child: const Text("Sign Up"),
                    style: TextButton.styleFrom(foregroundColor: Colors.teal),
                    onPressed: () => {context.go('/signup')},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
