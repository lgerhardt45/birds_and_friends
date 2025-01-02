import 'package:birds_and_friends/utils/logger.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  static Future<String?> getDownloadUrl(String path) async {
    try {
      Log.info("Pulling download URL for $path");
      return await FirebaseStorage.instance.ref(path).getDownloadURL();
    } catch (e) {
      Log.error('Error fetching download URL for $path: $e');
      return null;
    }
  }
}
