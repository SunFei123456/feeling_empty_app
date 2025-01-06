// 海域模型
class Ocean {
  final int id;
  final String name;
  final String body;
  final String bg;
  final int bottleCount;

  Ocean({
    required this.id,
    required this.name,
    required this.body,
    required this.bg,
    required this.bottleCount,
  });

  factory Ocean.fromJson(Map<String, dynamic> json) {
    return Ocean(
      id: json['id'] as int,
      name: json['name'] as String,
      body: json['body'] as String,
      bg: json['bg'] as String,
      bottleCount: json['bottle_count'] as int,
    );
  }
}