import 'package:birds_and_friends/utils/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  // create user in Firebase method
  void createUser(
      {required String firstName,
      required String lastName,
      required User firebaseAuthUser}) {
    Log.info("Creating user in Firestore");

    // get current user
    final user = firebaseAuthUser;

    // create user in Firestore
    try {
      FirestoreService().createUser(
        uid: user.uid,
        firstName: firstName,
        lastName: lastName,
        email: user.email!,
      );
      Log.info("User created in Firestore");
      // show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("User created successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      Log.error("Failed to create user in Firestore: $e");
      // show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to create user: $e"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }

  // sign user up
  void signUp() async {
    Log.info("Signing up");

    // check if passwords match
    if (passwordTextController.text != confirmPasswordTextController.text) {
      Log.error("Passwords do not match");
      // show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Passwords do not match"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // sign user up w/ email + password
    try {
      // sign user up
      Log.info("Signing up with email: ${emailTextController.text}");
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      Log.info("Signing up with email: ${emailTextController.text}");
    } on FirebaseAuthException catch (e) {
      Log.error("Failed to sign up: $e");
      // show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to sign up: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // create user in Firestore
    try {
      var firstName = firstNameTextController.text;
      var lastName = lastNameTextController.text;

      Log.info("Creating user $firstName $lastName in Firestore");
      createUser(
          firstName: firstName,
          lastName: lastName,
          firebaseAuthUser: FirebaseAuth.instance.currentUser!);
    } catch (e) {
      Log.error("Failed to create user: $e");
      // show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to create user: $e"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    return;
  }

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

                // first and last name inputs
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: BAFTextField(
                        controller: firstNameTextController,
                        hintText: 'First name',
                        obscureText: false,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: BAFTextField(
                        controller: lastNameTextController,
                        hintText: 'Last name',
                        obscureText: false,
                      ),
                    ),
                  ],
                ),
                // email input
                SizedBox(height: 12),
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
                BAFButton(onTap: signUp, text: 'Sign up'),

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
