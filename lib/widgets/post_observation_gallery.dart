import 'package:flutter/material.dart';
import '../models/observation.dart';
import '../models/bird.dart';

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

          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 4.0,
              right: index == observations.length - 1 ? 0 : 4.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    // Image
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(
                        image: AssetImage(observation.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
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
