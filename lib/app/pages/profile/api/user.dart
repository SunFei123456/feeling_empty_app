import 'package:fangkong_xinsheng/app/core/http/api_response.dart';
import 'package:fangkong_xinsheng/app/core/services/api_service.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:fangkong_xinsheng/app/pages/profile/model/user.dart';
class UserApiService extends BaseApiService {
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
