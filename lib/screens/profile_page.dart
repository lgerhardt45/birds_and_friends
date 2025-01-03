import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/logger.dart';

class BirdsAndFriendsProfilePage extends StatelessWidget {
  const BirdsAndFriendsProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'), // Title displayed in the app bar
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Sign out the user
              Log.info('Signing out');
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Text("Coming soon!"),
      ), // Placeholder text for the profile page
    );
  }
}
