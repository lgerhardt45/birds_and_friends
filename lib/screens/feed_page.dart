import 'package:birds_and_friends/models/user.dart';
import 'package:flutter/material.dart';
import 'package:birds_and_friends/utils/firestore_service.dart';
import 'package:birds_and_friends/utils/logger.dart';
import '../models/post.dart';
import '../models/bird.dart';
import '../widgets/post.dart';

class BirdsAndFriendsFeedPage extends StatefulWidget {
  const BirdsAndFriendsFeedPage({super.key});

  @override
  _BirdsAndFriendsFeedPageState createState() =>
      _BirdsAndFriendsFeedPageState();
}

class _BirdsAndFriendsFeedPageState extends State<BirdsAndFriendsFeedPage> {
  late Future<void> _loadDataFuture;
  List<Post> posts = [];
  List<Bird> birds = [];
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    try {
      FirestoreService firestoreService = FirestoreService();
      users = await firestoreService.loadUsers();
      Log.info('Users loaded: ${users.length}');

      posts = await firestoreService.loadPosts();
      Log.info('Posts loaded: ${posts.length}');

      birds = await firestoreService.loadBirds();
      Log.info('Birds loaded: ${birds.length}');
    } catch (e) {
      Log.error('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading data'));
        } else {
          // Map for quick bird lookups
          final birdMap = {for (var bird in birds) bird.id: bird};
          final userMap = {for (var user in users) user.id: user};

          // Sort posts by date (latest first)
          posts.sort((a, b) => b.date.compareTo(a.date));

          return Scaffold(
            appBar: AppBar(
              title: Text('Feed'), // Title displayed in the app bar
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final postUser = userMap[post.userId];

                      return PostWidget(
                        post: post,
                        observations: post.observations,
                        birdMap: birdMap,
                        user: postUser!,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
