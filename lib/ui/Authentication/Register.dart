import 'package:anix/services/auth.dart';
import 'package:anix/services/database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cpassword = TextEditingController();

  String? emailError;
  String? usernameError;
  String? passwordError;
  String? cpasswordError;
  String? errorMessage;
  bool isLoading = false;
  bool isGoogleLoading = false;

  final authService = AuthService();
  final dbService = Database(uid: '');

  bool validateForm() {
    bool isValid = true;
    setState(() {
      // Reset errors
      emailError = null;
      usernameError = null;
      passwordError = null;
      cpasswordError = null;

      // Username validation
      if (username.text.isEmpty) {
        usernameError = 'Username is required';
        isValid = false;
      } else if (username.text.length < 3) {
        usernameError = 'Username must be at least 3 characters';
        isValid = false;
      }

      // Email validation
      if (email.text.isEmpty) {
        emailError = 'Email is required';
        isValid = false;
      } else if (!RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      ).hasMatch(email.text)) {
        emailError = 'Please enter a valid email';
        isValid = false;
      }

      // Password validation
      if (password.text.isEmpty) {
        passwordError = 'Password is required';
        isValid = false;
      } else if (password.text.length < 4) {
        passwordError = 'Password must be at least 6 characters';
        isValid = false;
      }

      // Confirm password validation
      if (cpassword.text.isEmpty) {
        cpasswordError = 'Please re-type your password';
        isValid = false;
      } else if (password.text != cpassword.text) {
        cpasswordError = 'Passwords do not match';
        isValid = false;
      }
    });
    return isValid;
  }

  Future<void> handleSignUp() async {
    if (!validateForm()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      print('Username: ${username.text}');
      print('Password: ${password.text}');
      print('Email: ${email.text}');
      final isUsernameAvailable = await dbService.isUsernameAvailable(
        username.text,
      );

      print('USERNAMEEEEEEEEEEEEEEEEEEEEEE: $isUsernameAvailable');

      if (!isUsernameAvailable) {
        throw AuthException('Username is already taken');
      }
      final success = await authService.createUserWithEmailAndPassword(
        context: context,
        email: email.text.trim(),
        password: password.text.trim(),
        username: username.text.trim(),
      );

      if (success) {
        context.go('/login');
      }
    } on AuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Create a new account",
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
                      controller: username,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Username',
                        errorText: usernameError,
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
                      controller: email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Email',
                        errorText: emailError,
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
                        errorText: passwordError,
                      ),
                      obscureText: true,
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
                      controller: cpassword,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Confirm Password',
                        errorText: cpasswordError,
                      ),
                      obscureText: true,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.teal[600],
                    ),
                    child: TextButton(
                      onPressed: isLoading ? null : handleSignUp,
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
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    TextButton(
                      child: const Text("Login"),
                      style: TextButton.styleFrom(foregroundColor: Colors.teal),
                      onPressed: () => context.go('/login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
