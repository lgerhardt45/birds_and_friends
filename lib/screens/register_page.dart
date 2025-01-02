import 'package:flutter/material.dart';

import '../utils/logger.dart';
import '../widgets/button.dart';
import '../widgets/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controller
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Log.info("Building RegisterPage");

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
                Text("Let's create an account for you",
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

                // confirm password input
                SizedBox(height: 12),
                BAFTextField(
                  controller: confirmPasswordTextController,
                  hintText: 'Confirm password',
                  obscureText: true,
                ),

                // Register button
                SizedBox(height: 20),
                BAFButton(onTap: () {}, text: 'Sign up'),

                // go to register page
                SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text('Login now'),
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
