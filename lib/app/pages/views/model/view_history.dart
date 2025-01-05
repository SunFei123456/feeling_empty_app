class ViewHistoryResponse {
  final List<ViewHistoryItem> data;
  final int total;
  final int page;
  final int size;

  ViewHistoryResponse({
    required this.data,
    required this.total,
    required this.page,
    required this.size,
  });

  factory ViewHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ViewHistoryResponse(
      data: (json['data'] as List)
          .map((item) => ViewHistoryItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      size: json['size'] as int,
    );
  }
}

class ViewHistoryItem {
  final int id;
  final String title;
  final String content;
  final String imageUrl;
  final String audioUrl;
  final String mood;
  final int views;
  final int resonances;
  final DateTime createdAt;
  final UserInfo user;

  ViewHistoryItem({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.audioUrl,
    required this.mood,
    required this.views,
    required this.resonances,
    required this.createdAt,
    required this.user,
  });

  factory ViewHistoryItem.fromJson(Map<String, dynamic> json) {
    return ViewHistoryItem(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String,
      audioUrl: json['audio_url'] as String,
      mood: json['mood'] as String,
      views: json['views'] as int,
      resonances: json['resonances'] as int,
      createdAt: DateTime.parse(json['created_at']),
      user: UserInfo.fromJson(json['user']),
    );
  }
}

class UserInfo {
  final int id;
  final String nickname;
  final String avatar;
  final int sex;

  UserInfo({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.sex,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as int,
      nickname: json['nickname'] as String,
      avatar: json['avatar'] as String,
      sex: json['sex'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'avatar': avatar,
      'sex': sex,
    };
  }
} 