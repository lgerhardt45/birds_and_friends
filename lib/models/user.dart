import '../models/post.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? avatarPath;
  final DateTime createdAt;
  final List<Post> posts;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.avatarPath,
    required this.createdAt,
    this.posts = const [],
  });
}
