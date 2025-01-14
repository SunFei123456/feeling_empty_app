import 'package:fangkong_xinsheng/app/core/http/api_response.dart';
import 'package:fangkong_xinsheng/app/core/services/api_service.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:fangkong_xinsheng/app/pages/profile/model/follower.dart';
import 'package:fangkong_xinsheng/app/pages/profile/model/user.dart';

class UserApiService extends BaseApiService {
  // 根据uid 获取用户信息
  Future<ApiResponse<UserModel>> getUserInfoByUid(int uid) async {
    try {
      final response = await BaseApiService.dio.get('/users/$uid');
      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      print('Get user info error: $e');
      rethrow;
    }
  }

  // 获取用户信息
  Future<ApiResponse<UserModel>> getUserInfo() async {
    try {
      final response = await BaseApiService.dio.get('/users');
      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      print('Get user info error: $e');
      rethrow;
    }
  }

  // 修改用户信息
  Future<ApiResponse<void>> updateUserInfo({
    String? nickname,
    String? avatar,
    int? sex,
  }) async {
    try {
      final data = {
        if (nickname != null) 'nickname': nickname,
        if (avatar != null) 'avatar': avatar,
        if (sex != null) 'sex': sex,
      };

      final response = await BaseApiService.dio.put('/users', data: data);
      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json,
      );
    } catch (e) {
      print('Update user info error: $e');
      rethrow;
    }
  }

  // 获取两人的关注状态
  Future<ApiResponse<String>> getFollowStatus(int userId) async {
    try {
      final response =
          await BaseApiService.dio.get('/followees/user/$userId/follow_status');
      return ApiResponse.fromJson(
          response.data as Map<String, dynamic>, (json) => json as String);
    } catch (e) {
      print('Get follow status error: $e');
      rethrow;
    }
  }

  // 关注用户  /followees/user/6/follow
  Future<ApiResponse<void>> followUser(int userId) async {
    try {
      final response =
          await BaseApiService.dio.post('/followees/user/$userId/follow');
      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json,
      );
    } catch (e) {
      print('Follow user error: $e');
      rethrow;
    }
  }

  // 取消关注用户
  Future<ApiResponse<void>> unfollowUser(int userId) async {
    try {
      final response =
          await BaseApiService.dio.post('/followees/user/$userId/unfollow');
      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json,
      );
    } catch (e) {
      print('Unfollow user error: $e');
      rethrow;
    }
  }

  // 获取用户关注的人 /followees/user/5
  Future<ApiResponse<List<Follower>>> getFollowers(int userId) async {
    // int -> string
    final userIdStr = userId.toString();
    final response = await BaseApiService.dio.get('/followees/user/$userIdStr');
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List)
          .map((item) => Follower.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // 获取用户粉丝 // /followers/user/5
  Future<ApiResponse<List<Follower>>> getFans(int userId) async {
    // int -> string
    final userIdStr = userId.toString();

    final response = await BaseApiService.dio.get('/followers/user/$userIdStr');
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List)
          .map((item) => Follower.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // 获取用户公开的漂流瓶
  Future<ApiResponse<List<BottleModel>>> getBottles({
    required int userId,
    required int page,
    required int pageSize,
    required bool isPublic,
  }) async {
    try {
      final response = await BaseApiService.dio.get(
        '/bottles',
        queryParameters: {
          'is_public': isPublic,
          'page': page,
          'page_size': pageSize,
          'user_id': userId,
        },
      );

      print('Get public bottles response: ${response.data}');

      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => (json as List)
            .map((item) => BottleModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      print('Get public bottles error: $e');
      rethrow;
    }
  }
}
