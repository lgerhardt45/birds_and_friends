import 'package:flutter/material.dart';
import 'screens/feed_page.dart';
import 'screens/new_post_page.dart';
import 'screens/profile_page.dart';
import 'models/user.dart';
import 'models/post.dart';
import 'models/observation.dart';
import 'models/bird.dart';
import 'utils/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure b
  loadDataAndRunApp();
}

Future<void> loadDataAndRunApp() async {
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    Log.info('Firebase initialized successfully');

    // Load data from Firestore
    List<User> users = await loadUsersFromFirestore();
    Log.info('Users loaded: ${users.length}');

    List<Post> posts = await loadPostsFromFirestore();
    Log.info('Posts loaded: ${posts.length}');

    List<Observation> observations = await loadObservationsFromFirestore();
    Log.info('Observations loaded: ${observations.length}');

    List<Bird> birds = await loadBirdsFromFirestore();
    Log.info('Birds loaded: ${birds.length}');

    runApp(
      BirdsAndFriendsApp(
        users: users,
        posts: posts,
        observations: observations,
        birds: birds,
      ),
    );
  } catch (e) {
    Log.error('Error launching app: $e');
  }
}

// Firestore loading functions
Future<List<User>> loadUsersFromFirestore() async {
  try {
    FirebaseFirestore firestore =
        FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'main');
    QuerySnapshot querySnapshot = await firestore.collection('users').get();
    Log.info(
        'Users query executed: ${querySnapshot.docs.length} documents found');
    return querySnapshot.docs
        .map((doc) => User(
              id: doc.id,
              firstName: doc['firstName'],
              lastName: doc['lastName'],
              email: doc['email'],
            ))
        .toList();
  } catch (e) {
    Log.error('Error loading users from Firestore: $e');
    return [];
  }
}

Future<List<Post>> loadPostsFromFirestore() async {
  try {
    FirebaseFirestore firestore =
        FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'main');

    // Fetch the posts
    QuerySnapshot querySnapshot = await firestore.collection('posts').get();
    Log.info(
        'Posts query executed: ${querySnapshot.docs.length} documents found');

    // Map each post to a Post object with observationIds
    List<Post> posts = [];
    for (var doc in querySnapshot.docs) {
      // Fetch the observationIds for this post by querying its subcollection
      List<String> observationIds = await _getObservationIds(doc.id, firestore);

      // Create the Post object
      posts.add(Post(
        id: doc.id,
        location: doc['location'],
        date: (doc['date'] as Timestamp).toDate(),
        caption: doc['caption'],
        userId: doc['userId'],
        observationIds: observationIds,
      ));
    }

    return posts;
  } catch (e) {
    Log.error('Error loading posts from Firestore: $e');
    return [];
  }
}

Future<List<String>> _getObservationIds(
    String postId, FirebaseFirestore firestore) async {
  // Query the "Observations" subcollection for the given post
  QuerySnapshot observationSnapshot = await firestore
      .collection('posts')
      .doc(postId)
      .collection('observations')
      .get();

  // Extract the observation document IDs
  return observationSnapshot.docs.map((doc) => doc.id).toList();
}

Future<List<Observation>> loadObservationsFromFirestore() async {
  try {
    FirebaseFirestore firestore =
        FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'main');
    QuerySnapshot querySnapshot =
        await firestore.collection('observations').get();
    Log.info(
        'Observations query executed: ${querySnapshot.docs.length} documents found');
    return querySnapshot.docs
        .map((doc) => Observation(
              id: doc.id,
              birdId: doc['birdId'],
              numberBirds: doc['numberBirds'],
              imagePath: doc['imagePath'],
            ))
        .toList();
  } catch (e) {
    Log.error('Error loading observations from Firestore: $e');
    return [];
  }
}

Future<List<Bird>> loadBirdsFromFirestore() async {
  try {
    FirebaseFirestore firestore =
        FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'main');
    QuerySnapshot querySnapshot = await firestore.collection('birds').get();
    Log.info(
        'Birds query executed: ${querySnapshot.docs.length} documents found');
    return querySnapshot.docs
        .map((doc) => Bird(
              id: doc.id,
              germanName: doc['germanName'],
              englishName: doc['englishName'],
              scientificName: doc['scientificName'],
            ))
        .toList();
  } catch (e) {
    Log.error('Error loading birds from Firestore: $e');
    return [];
  }
}

class BirdsAndFriendsApp extends StatelessWidget {
  final List<User> users;
  final List<Post> posts;
  final List<Observation> observations;
  final List<Bird> birds;

  const BirdsAndFriendsApp(
      {super.key,
      required this.users,
      required this.posts,
      required this.observations,
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
      home: BirdsAndFriendsHome(
        posts: posts,
        observations: observations,
        birds: birds,
        users: users,
      ), // Sets the default home screen of the app
    );
  }
}

class BirdsAndFriendsHome extends StatefulWidget {
  final List<Post> posts;
  final List<Observation> observations;
  final List<Bird> birds;
  final List<User> users;

  const BirdsAndFriendsHome({
    super.key,
    required this.posts,
    required this.observations,
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
        observations: widget.observations,
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
