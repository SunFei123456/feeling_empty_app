// /// 登录注册模块 API
import 'package:fangkong_xinsheng/app/core/http/api_response.dart';
import 'package:fangkong_xinsheng/app/core/services/api_service.dart';
import 'package:fangkong_xinsheng/app/pages/login/model/login.dart';

class LoginApiService extends BaseApiService {
  // 登录功能
  Future<ApiResponse<LoginResponse>> login(LoginModel loginModel) async {
    try {
      final response = await BaseApiService.dio
          .post('/auth/login', data: loginModel.toJson());

      // 使用 response.data 而不是直接使用 response
      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => LoginResponse.fromJson(json),
      );
    } catch (e) {
      print('Login API error: $e');
      rethrow;
    }
  }

  // 发送qq邮箱验证码
  Future<ApiResponse<String>> sendQqEmailCode(String email) async {
    try {
      final response = await BaseApiService.dio
          .post('/auth/send-code', data: {'email': email});
      final responseData = response.data as Map<String, dynamic>;

      return ApiResponse<String>(
        code: responseData['code'] as int? ?? 500,
        message: responseData['message'] as String? ?? '',
        data: responseData['data'] as String? ?? '',
        success: responseData['code'] == 200,
      );
    } catch (e) {
      print('发送验证码失败: $e');
      rethrow;
    }
  }

  // qq验证码登录
  Future<ApiResponse<LoginResponse>> qqLogin(String email, String code) async {
    final response = await BaseApiService.dio
        .post('/auth/qq-email-login', data: {'email': email, 'code': code});
    return ApiResponse.fromJson(response.data as Map<String, dynamic>,
        (json) => LoginResponse.fromJson(json));
  }
}
