import 'package:fangkong_xinsheng/app/core/http/api_response.dart';
import 'package:fangkong_xinsheng/app/core/services/api_service.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/view_history.dart';

class ViewHistoryApiService extends BaseApiService {
  Future<ApiResponse<ViewHistoryResponse>> getViewHistory({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await BaseApiService.dio.get(
        '/bottle-views',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
      );
    
      final responseData = response.data as Map<String, dynamic>;
      return ApiResponse<ViewHistoryResponse>(
        code: responseData['code'] as int,
        message: responseData['message'] as String,
        data: ViewHistoryResponse.fromJson(responseData),
        success: responseData['code'] == 200,
      );
    } catch (e) {
      print('Get view history error: $e');
      rethrow;
    }
  }

  // 删除指定的浏览记录
  Future<ApiResponse<void>> deleteViewHistory(int id) async {
    final response = await BaseApiService.dio.delete('/bottle-views/$id');
    return ApiResponse.fromJson(response.data as Map<String, dynamic>, (json) {
      return null;
    });
  }

  // 清空浏览记录
  Future<ApiResponse<void>> clearViewHistory() async {
    final response = await BaseApiService.dio.delete('/bottle-views');
    return ApiResponse.fromJson(response.data as Map<String, dynamic>, (json) {
      return null;
    });
  }

  // 创建浏览历史记录
  // POST http://localhost:8080/api/v1/bottle-views?id=4
  Future<ApiResponse<void>> createViewHistory(int id) async {
    final response = await BaseApiService.dio.post('/bottle-views?id=$id');
    return ApiResponse.fromJson(response.data as Map<String, dynamic>, (json) {
      return null;
    });
  }
}
