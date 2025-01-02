import 'package:birds_and_friends/widgets/button.dart';
import 'package:birds_and_friends/widgets/text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controller
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  void _onTap() {
    // sign in logic
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // logo
                Icon(
                  Icons.lock,
                  size: 50,
                  color: Colors.green[500],
                ),

                // welcome back message
                Text("Welcome back, you've been missed!",
                    style: TextStyle(
                      color: Colors.grey[700],
                    )),

                SizedBox(height: 20),
                // email input
                BAFTextField(
                  controller: emailTextController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                // password input
                SizedBox(height: 12),
                BAFTextField(
                  controller: emailTextController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                SizedBox(height: 20),
                // sign in button
                BAFButton(onTap: _onTap, text: 'Sign in'),
                // go to register page
                SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {},
                      child: Text('Register'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
