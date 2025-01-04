import 'package:flutter/foundation.dart';

/// 漂流瓶创建请求模型
class CreateBottleRequest {
  final String? content;        // 文字内容
  final String? imageUrl;       // 图片URL
  final String? audioUrl;       // 音频URL
  final String mood;           // 心情
  final bool isPublic;         // 是否公开
  final int? topicId;          // 话题ID
  final String title;          // 标题

  CreateBottleRequest({
    this.content,
    this.imageUrl,
    this.audioUrl,
    required this.mood,
    required this.isPublic,
    this.topicId,
    required this.title,
  }) {
    // 验证内容有效性
    if (!isValid) {
      throw ArgumentError('Invalid bottle content: Must contain at least one of content, image, or audio');
    }
    // 验证图片和音频不能同时存在
    if (imageUrl != null && audioUrl != null) {
      throw ArgumentError('Invalid bottle content: Cannot contain both image and audio');
    }
  }

  /// 检查漂流瓶内容是否有效
  bool get isValid {
    return content != null || imageUrl != null || audioUrl != null;
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      if (content != null) 'content': content,
      if (imageUrl != null) 'image_url': imageUrl,
      if (audioUrl != null) 'audio_url': audioUrl,
      'mood': mood,
      'is_public': isPublic,
      if (topicId != null) 'topic_id': topicId,
      'title': title,
    };
  }

  /// 从JSON创建实例
  factory CreateBottleRequest.fromJson(Map<String, dynamic> json) {
    return CreateBottleRequest(
      content: json['content'] as String?,
      imageUrl: json['image_url'] as String?,
      audioUrl: json['audio_url'] as String?,
      mood: json['mood'] as String,
      isPublic: json['is_public'] as bool,
      topicId: json['topic_id'] as int?,
      title: json['title'] as String,
    );
  }

  /// 复制并修改实例
  CreateBottleRequest copyWith({
    String? content,
    String? imageUrl,
    String? audioUrl,
    String? mood,
    bool? isPublic,
    int? topicId,
    String? title,
  }) {
    return CreateBottleRequest(
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      mood: mood ?? this.mood,
      isPublic: isPublic ?? this.isPublic,
      topicId: topicId ?? this.topicId,
      title: title ?? this.title,
    );
  }

  @override
  String toString() {
    return 'CreateBottleRequest(content: $content, imageUrl: $imageUrl, '
        'audioUrl: $audioUrl, mood: $mood, isPublic: $isPublic, topicId: $topicId, title: $title)';
  }
}

/// 心情枚举
enum BottleMood {
  happy,    // 开心 😊
  sad,      // 难过 😢
  thinking, // 思考 🤔
  angry,    // 生气 😠
  excited,  // 期待 🥳
  tired,    // 疲惫 😴
  love,     // 喜欢 🥰
  surprised // 惊讶 😮
}

/// 心情扩展方法
extension BottleMoodExtension on BottleMood {
  String get value {
    return toString().split('.').last;
  }

  static BottleMood fromString(String mood) {
    return BottleMood.values.firstWhere(
      (e) => e.value == mood,
      orElse: () => throw ArgumentError('Invalid mood value: $mood'),
    );
  }
} 