import 'package:flutter/material.dart';
import '../models/observation.dart';
import '../models/bird.dart';
import 'bird_image.dart';

class PostObservationGallery extends StatelessWidget {
  final List<Observation> observations;
  final Map<String, Bird> birdMap; // A map for quick bird lookup by ID

  const PostObservationGallery({
    super.key,
    required this.observations,
    required this.birdMap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: observations.length,
        itemBuilder: (context, index) {
          final observation = observations[index];
          final bird = birdMap[observation.birdId];

          // padding between images
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 4.0,
              right: index == observations.length - 1 ? 0 : 4.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BirdImage('observation_images/$observation.imagePath'),
                SizedBox(height: 2),
                Text(
                  // Bird amount and name
                  '${observation.numberBirds}x ${bird?.englishName ?? 'Unknown Bird'}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
