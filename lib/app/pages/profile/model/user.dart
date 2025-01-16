import 'package:fangkong_xinsheng/app/core/services/token_service.dart';

class UserModel {
  final int id;
  final String nickname;
  final String avatar;
  final int sex;
  final String createdAt;
  final String updatedAt;
  int bottles;
  int follows;
  int followers;

  UserModel({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.sex,
    required this.createdAt,
    required this.updatedAt,
    this.bottles = 0,
    this.follows = 0,
    this.followers = 0
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // 处理只包含社交数据的情况
    if (json.containsKey('bottles') && !json.containsKey('id')) {
      return UserModel(
        id: 0, // 默认值
        nickname: '',
        avatar: '',
        sex: 0,
        createdAt: '',
        updatedAt: '',
        bottles: json['bottles'] as int? ?? 0,
        follows: json['follows'] as int? ?? 0,
        followers: json['followers'] as int? ?? 0
      );
    }
    
    // 处理完整用户数据的情况
    return UserModel(
      id: json['id'] as int? ?? 0,
      nickname: json['nickname'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      sex: json['sex'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      bottles: json['bottles'] as int? ?? 0,
      follows: json['follows'] as int? ?? 0,
      followers: json['followers'] as int? ?? 0 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'avatar': avatar,
      'sex': sex,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'bottles': bottles,
      'follows': follows,
      'followers': followers
    };
  }

  UserModel copyWith({
    int? id,
    String? nickname,
    String? avatar,
    int? sex,
    String? createdAt,
    String? updatedAt,
    int? bottles,
    int? follows,
    int? followers
  }) {
    return UserModel(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      sex: sex ?? this.sex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      bottles: bottles ?? this.bottles,
      follows: follows ?? this.follows,
      followers: followers ?? this.followers
    );
  }

  // 是否是当前用户
  bool get isCurrentUser => id == TokenService().getUserId();
}
