import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as path;
import 'package:fangkong_xinsheng/app/core/http/api_response.dart';
import 'package:fangkong_xinsheng/app/core/services/token_service.dart';

/// 文件上传服务
class UploadService {
  static String api = dotenv.get('Dev_Api');
  static final UploadService _instance = UploadService._internal();
  factory UploadService() => _instance;
  UploadService._internal();

  final _tokenService = TokenService();

  /// 获取上传凭证和临时URL
  Future<Map<String, dynamic>> _getUploadToken(String ext) async {
    try {
      final token = _tokenService.getToken();
      if (token == null) {
        throw Exception('未登录');
      }

      final response = await Dio().get(
        'http://$api/api/v1/cos/upload-token',
        queryParameters: {'ext': ext},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['code'] == 200) {
        return response.data['data'];
      } else {
        throw Exception('获取上传凭证失败: ${response.data['message']}');
      }
    } catch (e) {
      print('获取上传凭证错误: $e');
      rethrow;
    }
  }

  /// 上传文件
  Future<ApiResponse<String>> _uploadFile(String filePath) async {
    try {
      String ext = path.extension(filePath).substring(1);

      // 获取上传凭证和临时URL
      final uploadData = await _getUploadToken(ext);

      String uploadUrl = uploadData['url'];
      String contentType = uploadData['content_type'];

      // 上传文件
      File file = File(filePath);
      final response = await Dio().put(
        uploadUrl,
        data: file.openRead(),
        options: Options(
          headers: {
            'Content-Length': await file.length(),
            'Content-Type': contentType,
          },
        ),
      );

      if (response.statusCode == 200) {
        // 构建访问URL
        String fileUrl =
            'https://${uploadData['bucket']}.cos.${uploadData['region']}.myqcloud.com/${uploadData['key']}';

        return ApiResponse(
          success: true,
          data: fileUrl,
          message: '上传成功',
          code: 200,
        );
      } else {
        throw Exception('上传失败: ${response.statusMessage}');
      }
    } catch (e) {
      print('上传错误: $e');
      return ApiResponse(
        success: false,
        message: e.toString(),
        code: 500,
      );
    }
  }

  /// 上传图片
  Future<ApiResponse<String>> uploadImage(String filePath) =>
      _uploadFile(filePath);

  /// 上传音频
  Future<ApiResponse<String>> uploadAudio(String filePath) =>
      _uploadFile(filePath);
}
