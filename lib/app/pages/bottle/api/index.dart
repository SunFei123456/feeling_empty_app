// /// 登录注册模块 API
import 'package:fangkong_xinsheng/app/core/http/api_response.dart';
import 'package:fangkong_xinsheng/app/core/services/api_service.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/model/hot_bottle_response.dart';
import 'package:fangkong_xinsheng/app/pages/login/model/login.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/model/index.dart';
import 'package:fangkong_xinsheng/app/core/services/upload_service.dart';

class BottleApiService extends BaseApiService {
  final _uploadService = UploadService();
  
  /// 创建漂流瓶
  Future<ApiResponse<void>> createBottle(CreateBottleRequest request) async {
    try {
      final response = await BaseApiService.dio.post(
        '/bottles',
        data: request.toJson(),
      );
      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json,
      );
    } catch (e) {
      print('Create bottle error: $e');
      rethrow;
    }
  }
  
  /// 获取热门的漂流瓶 http://8.152.194.158:8080/api/v1/bottles/hot?page_size=10&page=1
  Future<ApiResponse<HotBottlesResponse>> getHotBottles(
    int pageSize,
    int page, {
    String timeRange = 'week',
  }) async {
    try {
      print('Fetching bottles for time range: $timeRange');
      final response = await BaseApiService.dio.get(
        '/bottles/hot',
        queryParameters: {
          'page_size': pageSize,
          'page': page,
          'time_range': timeRange,
        },
      );
      
      // 打印完整的 URL 和响应
      print('Request URL: ${response.realUri}');
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['data'] != null) {
        final hotBottlesResponse = HotBottlesResponse.fromJson(responseData['data'] as Map<String, dynamic>);
        print('Parsed bottles count: ${hotBottlesResponse.bottles.length}');
      } else {
        print('Response data is null');
      }

      return ApiResponse<HotBottlesResponse>(
        code: responseData['code'] as int? ?? 500,
        message: responseData['message'] as String? ?? 'Unknown error',
        data: responseData['data'] != null 
            ? HotBottlesResponse.fromJson(responseData['data'] as Map<String, dynamic>)
            : null,
        success: responseData['code'] == 200,
      );
    } catch (e, stackTrace) {
      print('Get hot bottles error for $timeRange: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// 上传图片（代理到通用上传服务）
  Future<ApiResponse<String>> uploadImage(String filePath) => 
      _uploadService.uploadImage(filePath);

  /// 上传音频（代理到通用上传服务）
  Future<ApiResponse<String>> uploadAudio(String filePath) => 
      _uploadService.uploadAudio(filePath);


  /// 删除漂流瓶
  Future<ApiResponse<void>> deleteBottle(int bottleId) async {
    try {
      final response = await BaseApiService.dio.delete(
        '/bottles/$bottleId',
      );
      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json,
      );
    } catch (e) {
      print('Delete bottle error: $e');
      rethrow;
    }
  }

  /// 修改瓶子可见性
  Future<ApiResponse<void>> updateBottleVisibility(int bottleId, bool isPublic) async {
    try {
      final response = await BaseApiService.dio.put(
        '/bottles/$bottleId',
        data: {
          'is_public': isPublic,
        },
      );
      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json,
      );
    } catch (e) {
      print('Update bottle visibility error: $e');
      rethrow;
    }
  }
}
