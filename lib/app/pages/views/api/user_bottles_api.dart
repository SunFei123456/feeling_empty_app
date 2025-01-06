import 'package:fangkong_xinsheng/app/core/http/api_response.dart';
import 'package:fangkong_xinsheng/app/core/services/api_service.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/view_history.dart';

class BottleInteractionApiService extends BaseApiService {
  // 获取用户收藏的漂流瓶
  Future<ApiResponse<List<ViewHistoryItem>>> getFavoritedBottles({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await BaseApiService.dio.get(
        '/bottles/favorited',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
      );
      
      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => (json as List)
            .map((item) => ViewHistoryItem.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      print('Get favorited bottles error: $e');
      rethrow;
    }
  }

  // 获取用户共振的漂流瓶
  Future<ApiResponse<List<ViewHistoryItem>>> getResonatedBottles({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await BaseApiService.dio.get(
        '/bottles/resonated',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
      );
      
      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => (json as List)
            .map((item) => ViewHistoryItem.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      print('Get resonated bottles error: $e');
      rethrow;
    }
  }

  // 共振(喜欢)漂流瓶
  Future<ApiResponse<void>> resonateBottle(int bottleId) async {
    try {
      final response = await BaseApiService.dio.post('/bottles/$bottleId/resonate');
      return ApiResponse.fromJson(response.data as Map<String, dynamic>, (json) => null);
    } catch (e) {
      print('Resonate bottle error: $e');
      rethrow;
    }
  }

  // 取消共振(取消喜欢)
  Future<ApiResponse<void>> unresonateBottle(int bottleId) async {
    try {
      final response = await BaseApiService.dio.delete('/bottles/$bottleId/resonate');
      return ApiResponse.fromJson(response.data as Map<String, dynamic>, (json) => null);
    } catch (e) {
      print('Unresonate bottle error: $e');
      rethrow;
    }
  }

  // 收藏漂流瓶
  Future<ApiResponse<void>> favoriteBottle(int bottleId) async {
    try {
      final response = await BaseApiService.dio.post('/bottles/$bottleId/favorite');
      return ApiResponse.fromJson(response.data as Map<String, dynamic>, (json) => null);
    } catch (e) {
      print('Favorite bottle error: $e');
      rethrow;
    }
  }

  // 取消收藏
  Future<ApiResponse<void>> unfavoriteBottle(int bottleId) async {
    try {
      final response = await BaseApiService.dio.delete('/bottles/$bottleId/favorite');
      return ApiResponse.fromJson(response.data as Map<String, dynamic>, (json) => null);
    } catch (e) {
      print('Unfavorite bottle error: $e');
      rethrow;
    }
  }
} 