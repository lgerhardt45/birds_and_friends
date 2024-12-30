import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/post.dart';
import '../models/observation.dart';
import '../models/bird.dart';
import 'post_observation_gallery.dart';
import '../models/user.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final List<Observation> observations;
  final User? user;
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
    final postObservations = observations
        .where((obs) => post.observationIds.contains(obs.id))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        // whole Post container
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(// User info
              children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: Icon(
                Icons.person,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${DateFormat('dd.MM.yyyy HH:mm').format(post.date)} - ${post.location}',
                  style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                ),
              ],
            )
          ]),
          SizedBox(height: 4),
          SizedBox(
            height: 200, // Ensure the gallery has a fixed height
            child: PostObservationGallery(
              // Post images (observations)
              observations: postObservations,
              birdMap: birdMap,
            ),
          ),
          Row(
            // Interaction buttons
            children: [
              IconButton(
                icon: Icon(Icons.thumb_up_sharp),
                onPressed: () {
                  // Handle like button press
                },
              ),
              IconButton(
                icon: Icon(Icons.comment),
                onPressed: () {
                  // Handle comment button press
                },
              ),
            ],
          ),
          SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.black),
              children: [
                TextSpan(
                  text: '${user?.firstName ?? ''} ',
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
