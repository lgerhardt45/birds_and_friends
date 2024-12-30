import 'package:flutter/material.dart';

class BirdsAndFriendsProfilePage extends StatelessWidget {
  const BirdsAndFriendsProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'), // Title displayed in the app bar
      ),
      body: Center(
        child: Text(
          'Profile Page Content', // Placeholder text for the profile page
          style: TextStyle(fontSize: 18), // Styling for the content
        ),
      ),
    );
  }
}
