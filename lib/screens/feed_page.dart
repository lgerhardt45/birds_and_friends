import 'package:birds_and_friends/models/user.dart';
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/observation.dart';
import '../models/bird.dart';
import '../widgets/post.dart';

class BirdsAndFriendsFeedPage extends StatelessWidget {
  final List<Post> posts;
  final List<Observation> observations;
  final List<Bird> birds;
  final List<User> users;

  const BirdsAndFriendsFeedPage({
    super.key,
    required this.posts,
    required this.observations,
    required this.birds,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
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
                  observations: observations,
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
}
