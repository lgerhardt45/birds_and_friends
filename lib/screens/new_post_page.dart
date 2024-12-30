import 'package:flutter/material.dart';

class BirdsAndFriendsNewPostPage extends StatelessWidget {
  const BirdsAndFriendsNewPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'), // Title displayed in the app bar
      ),
      body: Center(
        child: Text(
          'New Post Page Content', // Placeholder text for the new post page
          style: TextStyle(fontSize: 18), // Styling for the content
        ),
      ),
    );
  }
}
