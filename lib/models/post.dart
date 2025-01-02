import '../models/observation.dart';

class Post {
  final String id;
  final DateTime date;
  final String location;
  final String caption;
  final String userId;
  final List<Observation> observations;

  Post({
    required this.id,
    required this.date,
    required this.location,
    required this.caption,
    required this.userId,
    this.observations = const [],
  });
}
