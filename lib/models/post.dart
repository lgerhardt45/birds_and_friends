class Post {
  final String id;
  final DateTime date;
  final String location;
  final String caption;
  final String userId;
  final List<String> observationIds;

  Post({
    required this.id,
    required this.date,
    required this.location,
    required this.caption,
    required this.userId,
    this.observationIds = const [],
  });
}
