import 'package:flutter/material.dart';
import 'screens/feed_page.dart';
import 'screens/new_post_page.dart';
import 'screens/profile_page.dart';
import 'utils/login_or_register.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BirdsAndFriendsApp());
}

class BirdsAndFriendsApp extends StatelessWidget {
  const BirdsAndFriendsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birds & Friends', // Name of the app displayed in app switchers
      theme: ThemeData(
        primarySwatch: Colors.green, // Primary color theme of the app
        visualDensity: VisualDensity
            .adaptivePlatformDensity, // Adapts UI density to the platform
      ),
      home: LoginOrRegister(),
    );
  }
}

class BirdsAndFriendsHome extends StatefulWidget {
  const BirdsAndFriendsHome({super.key});

  @override
  BirdsAndFriendsHomeState createState() => BirdsAndFriendsHomeState();
}

class BirdsAndFriendsHomeState extends State<BirdsAndFriendsHome> {
  int _selectedIndex = 0; // Tracks the selected tab index

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      BirdsAndFriendsFeedPage(),
      BirdsAndFriendsNewPostPage(),
      BirdsAndFriendsProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Updates the selected tab index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Displays the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icon for the Feed tab
            label: 'Feed', // Label for the Feed tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt), // Icon for the New Post tab
            label: 'New Post', // Label for the New Post tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Icon for the Profile tab
            label: 'Profile', // Label for the Profile tab
          ),
        ],
        onTap: _onItemTapped, // Handles tab selection
      ),
    );
  }
}
