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
}
