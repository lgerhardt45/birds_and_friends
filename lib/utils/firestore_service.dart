import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../models/observation.dart';
import '../models/bird.dart';
import 'logger.dart';

class FirestoreService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'main');

  void createUser(
      {required String uid,
      required String firstName,
      required String lastName,
      required String email}) {
    try {
      _firestore.collection('users').doc(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'avatarPath': '',
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'User', // default User
      });
      Log.info('User created in Firestore: ${uid}');
    } catch (e) {
      Log.error('Error creating user in Firestore: $e');
    }
  }

  Future<List<User>> loadUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      Log.info(
          'Users query executed: ${querySnapshot.docs.length} documents found');
      return querySnapshot.docs
          .map((doc) => User(
                id: doc.id,
                firstName: doc['firstName'],
                lastName: doc['lastName'],
                email: doc['email'],
                avatarPath: doc['avatarPath'],
              ))
          .toList();
    } catch (e) {
      Log.error('Error loading users from Firestore: $e');
      return [];
    }
  }

  Future<List<Post>> loadPosts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('posts').get();
      Log.info(
          'Posts query executed: ${querySnapshot.docs.length} documents found');

      List<Post> posts = [];
      for (var doc in querySnapshot.docs) {
        List<Observation> observations = await _getObservations(doc.id);
        posts.add(Post(
          id: doc.id,
          location: doc['location'],
          date: (doc['date'] as Timestamp).toDate(),
          caption: doc['caption'],
          userId: doc['userId'],
          observations: observations,
        ));
      }
      return posts;
    } catch (e) {
      Log.error('Error loading posts from Firestore: $e');
      return [];
    }
  }

  Future<List<Observation>> _getObservations(String postId) async {
    try {
      QuerySnapshot observationSnapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('observations')
          .get();
      Log.info(
          'Observations query executed for post $postId: ${observationSnapshot.docs.length} documents found');
      return observationSnapshot.docs.map((doc) {
        DocumentReference birdRef = doc['birdId'];
        return Observation(
          id: doc.id,
          birdId: birdRef.id,
          numberBirds: doc['numberBirds'] as int,
          imagePath: doc['imagePath'],
        );
      }).toList();
    } catch (e) {
      Log.error(
          'Error loading observations for post $postId from Firestore: $e');
      return [];
    }
  }

  Future<List<Bird>> loadBirds() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('birds').get();
      Log.info(
          'Birds query executed: ${querySnapshot.docs.length} documents found');
      return querySnapshot.docs
          .map((doc) => Bird(
                id: doc.id,
                germanName: doc['germanName'],
                englishName: doc['englishName'],
                scientificName: doc['scientificName'],
              ))
          .toList();
    } catch (e) {
      Log.error('Error loading birds from Firestore: $e');
      return [];
    }
  }
}
