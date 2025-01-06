import 'package:fangkong_xinsheng/app/pages/views/model/view_history.dart';

class BottleCardModel {
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
  

  BottleCardModel({
    required this.id,
    this.audioUrl = '',
    this.content = '',
    this.title = '',
    required this.createdAt,
    this.imageUrl = '',
    required this.mood,
    this.topicId = 0,
    required this.user,
    this.views = 0,
  });

  factory BottleCardModel.fromJson(Map<String, dynamic> json) {
    return BottleCardModel(
      id: json['id'] as int? ?? 0,
      audioUrl: json['audio_url'] as String? ?? '',
      content: json['content'] as String? ?? '',
      title: json['title'] as String? ?? '默认的标题',
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      imageUrl: json['image_url'] as String? ?? '',
      mood: json['mood'] as String? ?? 'unknown',
      topicId: json['topic_id'] as int? ?? 0,
      user: UserInfo(
        id: (json['user'] as Map<String, dynamic>?)?['id'] as int? ?? json['user_id'] as int? ?? 0,
        nickname: (json['user'] as Map<String, dynamic>?)?['nickname'] as String? ?? '用户${json['user_id'] ?? 0}',
        avatar: (json['user'] as Map<String, dynamic>?)?['avatar'] as String? ?? '',
        sex: (json['user'] as Map<String, dynamic>?)?['sex'] as int? ?? 0,
      ),
      views: json['views'] as int? ?? 0,
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
    };
  }
} 