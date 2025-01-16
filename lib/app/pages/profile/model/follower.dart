
import 'package:fangkong_xinsheng/app/pages/profile/model/user.dart';

class Follower {
  String? followeeId;
  String followAt;
  String followStatus;
  UserModel? user;

  Follower(this.followeeId, this.followAt, this.followStatus, this.user);

  factory Follower.fromJson(Map<dynamic, dynamic> json) {
    return Follower(
      json['followee_id'],
      json['follow_at'],
      json['follow_status'],
      json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['followee_id'] = followeeId;
    data['follow_at'] = followAt;
    data['follow_status'] = followStatus;
    data['user'] = user?.toJson();
    return data;
  }
}
