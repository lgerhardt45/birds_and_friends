import 'package:flutter/material.dart';
import '../utils/logger.dart';
import '../widgets/button.dart';
import '../widgets/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controller
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Log.info("Building LoginPage");
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

                // email input
                SizedBox(height: 20),
                BAFTextField(
                  controller: emailTextController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                // password input
                SizedBox(height: 12),
                BAFTextField(
                  controller: passwordTextController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                // sign in button
                SizedBox(height: 20),
                BAFButton(onTap: () {}, text: 'Sign in'),

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
                      onTap: widget.onTap,
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
