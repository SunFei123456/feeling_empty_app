import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';

class ViewHistoryResponse {
  final List<BottleModel> data;
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
      data: (json['data'] as List).map((item) => BottleModel.fromJson(item)).toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      size: json['size'] as int,
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
