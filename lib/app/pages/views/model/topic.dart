class Topic {
  final int id;
  final String title;
  final int contentCount;

  Topic({
    required this.id,
    required this.title,
    required this.contentCount,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] as int,
      title: json['title'] as String,
      contentCount: json['content_count'] as int,
    );
  }
} 