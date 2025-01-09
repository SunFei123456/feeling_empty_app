import 'package:fangkong_xinsheng/app/pages/views/model/view_history.dart';

class BottleModel {
  final int id;
  final String audioUrl;
  final String content;
  final String title;
  final String createdAt;
  final String imageUrl;
  final String mood;
  final int topicId;
  final UserInfo user;
  final int views;
  final bool isResonated;
  final bool isFavorited;
  final int resonates;
  // final int favorites;

  const BottleModel({
    required this.id,
    this.audioUrl = '',
    this.content = '',
    this.title = '',
    this.createdAt = '',
    this.imageUrl = '',
    this.mood = 'unknown',
    this.topicId = 0,
    required this.user,
    this.views = 0,
    this.isResonated = false,
    this.isFavorited = false,
    this.resonates = 0,
    // this.favorites = 0,
  });

  factory BottleModel.fromJson(Map<String, dynamic> json) {
    return BottleModel(
      id: json['id'] as int,
      audioUrl: json['audio_url'] as String? ?? '',
      content: json['content'] as String? ?? '',
      title: json['title'] as String? ?? '',
      createdAt:
          json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      imageUrl: json['image_url'] as String? ?? '',
      mood: json['mood'] as String? ?? 'unknown',
      topicId: json['topic_id'] as int? ?? 0,
      user: UserInfo(
        id: (json['user'] as Map<String, dynamic>?)?['id'] as int? ?? 0,
        nickname:
            (json['user'] as Map<String, dynamic>?)?['nickname'] as String? ??
                '未知用户',
        avatar:
            (json['user'] as Map<String, dynamic>?)?['avatar'] as String? ?? '',
        sex: (json['user'] as Map<String, dynamic>?)?['sex'] as int? ?? 0,
      ),
      views: json['views'] as int? ?? 0,
      resonates: json['resonances'] as int? ?? 0,
      // favorites: json['favorites'] as int? ?? 0,
      isResonated: json['is_resonated'] as bool? ?? false,
      isFavorited: json['is_favorited'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'audio_url': audioUrl,
      'content': content,
      'title': title,
      'created_at': createdAt,
      'image_url': imageUrl,
      'mood': mood,
      'topic_id': topicId,
      'user': user.toJson(),
      'views': views,
      'resonates': resonates,
      // 'favorites': favorites,
      'is_resonated': isResonated,
      'is_favorited': isFavorited,

    
    };
  }
}
