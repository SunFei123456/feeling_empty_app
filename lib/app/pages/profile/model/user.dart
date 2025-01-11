import 'package:fangkong_xinsheng/app/core/services/token_service.dart';

class UserModel {
  final int id;
  final String nickname;
  final String avatar;
  final int sex;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.sex,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      nickname: json['nickname'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      sex: json['sex'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
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
    };
  }

  UserModel copyWith({
    int? id,
    String? nickname,
    String? avatar,
    int? sex,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      sex: sex ?? this.sex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // 是否是当前用户
  bool get isCurrentUser => id == TokenService().getUserId();
} 