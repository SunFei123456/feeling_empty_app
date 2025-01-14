// 关注模块的接口

import 'package:fangkong_xinsheng/app/core/http/api_response.dart';
import 'package:fangkong_xinsheng/app/core/services/api_service.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/ocean.dart';

class FollowApiService extends BaseApiService {
  // 关注
  Future<ApiResponse<bool>> follow(int oceanId) async {
    try {
      final response = await BaseApiService.dio.post('/oceans/$oceanId/follow');
      final responseData = response.data as Map<String, dynamic>;
      return ApiResponse<bool>(
        code: responseData['code'] as int,
        message: responseData['message'] as String,
        data: responseData['data'] as bool,
        success: responseData['code'] == 200,
      );
    } catch (e) {
      print('Follow error: $e');
      rethrow;
    }
  }

  // 取消关注
  Future<ApiResponse<bool>> unfollow(int oceanId) async {
    try {
      final response = await BaseApiService.dio.delete('/oceans/$oceanId/follow');
      final responseData = response.data as Map<String, dynamic>;
      return ApiResponse<bool>(
        code: responseData['code'] as int,
        message: responseData['message'] as String,
        data: responseData['data'] as bool,
        success: responseData['code'] == 200,
      );
    } catch (e) {
      print('Unfollow error: $e');
      rethrow;
    }
  }

  // 获取关注的人列表
  // Future<ApiResponse<List<Ocean>>> getFollows() async {
  //   try {
  //     final response = await BaseApiService.dio.get('/follows');
  //     final responseData = response.data as Map<String, dynamic>;
  //     if (responseData['data'] != null) {
  //       return ApiResponse<List<Ocean>>(
  //         code: responseData['code'] as int,
  //         message: responseData['message'] as String,
  //         data: (responseData['data'] as List)
  //             .map((item) => Ocean.fromJson(item as Map<String, dynamic>))
  //             .toList(),
  //         success: responseData['code'] == 200,
  //       );
  //     }
  //     return ApiResponse<List<Ocean>>(
  //       code: responseData['code'] as int,
  //       message: responseData['message'] as String,
  //       data: [],
  //       success: false,
  //     );
  //   } catch (e) {
  //     print('Get follows error: $e');
  //     rethrow;
  //   }
  // }
  
}
