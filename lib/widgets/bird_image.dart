import 'package:flutter/material.dart';
import '../utils/firebase_storage_service.dart';

class BirdImage extends StatelessWidget {
  final String imagePath;

  const BirdImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: FirebaseStorageService.getDownloadUrl(imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Icon(Icons.error));
        } else {
          return Image.network(snapshot.data!);
        }
      },
    );
  }
}
