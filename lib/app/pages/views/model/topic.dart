class Topic {
  final int id;
  final String title;
  final String bgImage;
  final int? views;
  final String? description;

  Topic({
    required this.id,
    required this.title,
    required this.bgImage,
    this.description,
    this.views = 0,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      bgImage: json['bg_image'] ?? '',
      views: json['views'] ?? 0,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'bg_image': bgImage,
      'description': description,
    };
  }
}
