import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class BirdImage extends StatelessWidget {
  final String imageUrl;

  const BirdImage(this.imageUrl, {super.key});

  Future<String> getDownloadUrl(String filePath) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(filePath);
    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // height: 300,
        // width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey[300],
        ),
        child: FutureBuilder(
          future: getDownloadUrl(imageUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a placeholder while loading
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              // Show an error placeholder
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    Text(snapshot.error.toString()),
                  ],
                ),
              );
            }
            return Image.network(snapshot.data!);
          },
        ),
      ),
    );
  }
}
