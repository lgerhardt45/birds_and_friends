import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'screens/feed_page.dart';
import 'screens/new_post_page.dart';
import 'screens/profile_page.dart';
import 'models/user.dart';
import 'models/post.dart';
import 'models/observation.dart';
import 'models/bird.dart';
import 'utils/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure b
  loadDataAndRunApp();
}

Future<void> loadDataAndRunApp() async {
  try {
    // load sample data
    List<User> users = await loadSampleUsers();
    Log.info('Sample users loaded: ${users.length}');

    List<Post> posts = await loadSamplePosts();
    Log.info('Sample posts loaded: ${posts.length}');

    List<Observation> observations = await loadSampleObservations();
    Log.info('Sample observations loaded: ${observations.length}');

    List<Bird> birds = await loadSampleBirds();
    Log.info('Sample birds loaded: ${birds.length}');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

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

Future<List<User>> loadSampleUsers() async {
  final String csvString =
      await rootBundle.loadString('assets/sample_data/tables/users.csv');
  final List<List<dynamic>> csvData =
      const CsvToListConverter(eol: '\n').convert(csvString);

  return csvData.skip(1).map((row) {
    return User(
      id: row[0],
      firstName: row[1],
      lastName: row[2],
      email: row[3],
    );
  }).toList();
}

Future<List<Post>> loadSamplePosts() async {
  final String csvString =
      await rootBundle.loadString('assets/sample_data/tables/posts.csv');
  final List<List<dynamic>> csvData =
      const CsvToListConverter(eol: '\n').convert(csvString);

  return csvData.skip(1).where((row) => row[6] == "TRUE").map((row) {
    return Post(
        id: row[0],
        location: row[1],
        date: DateTime.parse(row[2]),
        caption: row[3],
        userId: row[4],
        observationIds: row[5].split(','));
  }).toList();
}

Future<List<Observation>> loadSampleObservations() async {
  final String path = 'assets/sample_data/tables/observations.csv';
  final String csvString = await rootBundle.loadString(path);

  final List<List<dynamic>> csvData =
      const CsvToListConverter(eol: '\n').convert(csvString);

  final List<Observation> observations = csvData.skip(1).map((row) {
    return Observation(
      id: row[0],
      birdId: row[1],
      numberBirds: row[2],
      imagePath: row[3],
    );
  }).toList();

  return observations;
}

Future<List<Bird>> loadSampleBirds() async {
  final String csvString =
      await rootBundle.loadString('assets/sample_data/tables/birds.csv');
  final List<List<dynamic>> csvData =
      const CsvToListConverter(eol: '\n').convert(csvString);

  return csvData.skip(1).map((row) {
    return Bird(
      id: row[0],
      germanName: row[1],
      englishName: row[2],
      scientificName: row[3],
    );
  }).toList();
}
