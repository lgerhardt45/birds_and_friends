import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/post.dart';
import '../models/observation.dart';
import '../models/bird.dart';
import '../models/user.dart';
import 'post_observation_gallery.dart';
import '../utils/firebase_storage_service.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final List<Observation> observations;
  final User user;
  final Map<String, Bird> birdMap;

  const PostWidget({
    super.key,
    required this.post,
    required this.observations,
    required this.user,
    required this.birdMap,
  });

  @override
  Widget build(BuildContext context) {
    final postObservations = observations;

    return Padding(
      // consistent padding around all posts
      padding: const EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        bottom: 24.0,
      ),
      child: Column(
        // whole Post container
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar, name, post date and location
          Row(
            children: [
              FutureBuilder<String?>(
                future: FirebaseStorageService.getDownloadUrl(
                  'user_avatars/${user.avatarPath}',
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: NetworkImage(snapshot.data!),
                    );
                  } else {
                    return CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: Icon(
                        Icons.person,
                        color: Colors.grey.shade800,
                      ),
                    );
                  }
                },
              ),
              SizedBox(width: 8),
              // User name, below post date and location
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${DateFormat('dd.MM.yyyy HH:mm').format(post.date)} - ${post.location}',
                    style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 8),
          PostObservationGallery(
            // Post images (observations)
            observations: postObservations,
            birdMap: birdMap,
          ),
          Row(
            // Interaction buttons
            children: [
              IconButton(
                icon: Icon(Icons.favorite),
                iconSize: 30,
                padding: EdgeInsets.zero,
                onPressed: () {
                  // Handle like button press
                },
              ),
              IconButton(
                icon: Icon(Icons.comment),
                iconSize: 30,
                padding: EdgeInsets.zero,
                onPressed: () {
                  // Handle comment button press
                },
              ),
            ],
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.black),
              children: [
                TextSpan(
                  text: '${user.firstName}  ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: post.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
