import 'package:birds_and_friends/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'screens/feed_page.dart';
import 'screens/new_post_page.dart';
import 'screens/profile_page.dart';
import 'models/user.dart';
import 'models/post.dart';
import 'models/bird.dart';
import 'utils/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'utils/firestore_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  loadDataAndRunApp();
}

Future<void> loadDataAndRunApp() async {
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    Log.info('Firebase initialized successfully');

    // Load data from Firestore using FirestoreService
    FirestoreService firestoreService = FirestoreService();
    List<User> users = await firestoreService.loadUsers();
    Log.info('Users loaded: ${users.length}');

    List<Post> posts = await firestoreService.loadPosts();
    Log.info('Posts loaded: ${posts.length}');

    List<Bird> birds = await firestoreService.loadBirds();
    Log.info('Birds loaded: ${birds.length}');

    runApp(
      BirdsAndFriendsApp(
        users: users,
        posts: posts,
        birds: birds,
      ),
    );
  } catch (e) {
    Log.error('Error launching app: $e');
  }
}

class BirdsAndFriendsApp extends StatelessWidget {
  final List<User> users;
  final List<Post> posts;
  final List<Bird> birds;

  const BirdsAndFriendsApp(
      {super.key,
      required this.users,
      required this.posts,
      required this.birds});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birds & Friends', // Name of the app displayed in app switchers
      theme: ThemeData(
        primarySwatch: Colors.green, // Primary color theme of the app
        visualDensity: VisualDensity
            .adaptivePlatformDensity, // Adapts UI density to the platform
      ),
      home: LoginPage(),
      // home: BirdsAndFriendsHome(
      //   posts: posts,
      //   birds: birds,
      //   users: users,
      // ), // Sets the default home screen of the app
    );
  }
}

class BirdsAndFriendsHome extends StatefulWidget {
  final List<Post> posts;
  final List<Bird> birds;
  final List<User> users;

  const BirdsAndFriendsHome({
    super.key,
    required this.posts,
    required this.birds,
    required this.users,
  });

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
      BirdsAndFriendsFeedPage(
        posts: widget.posts,
        birds: widget.birds,
        users: widget.users,
      ),
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
