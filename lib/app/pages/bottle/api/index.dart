// /// 登录注册模块 API
import 'package:fangkong_xinsheng/app/core/http/api_response.dart';
import 'package:fangkong_xinsheng/app/core/services/api_service.dart';
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
  

  /// 上传图片（代理到通用上传服务）
  Future<ApiResponse<String>> uploadImage(String filePath) => 
      _uploadService.uploadImage(filePath);

  /// 上传音频（代理到通用上传服务）
  Future<ApiResponse<String>> uploadAudio(String filePath) => 
      _uploadService.uploadAudio(filePath);
}
