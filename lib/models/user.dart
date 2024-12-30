import '../models/post.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final List<Post> posts;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.posts = const [],
  });
}