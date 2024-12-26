import 'package:get/get.dart';
import 'package:getx_study/app/core/services/api_service.dart';
import 'package:getx_study/app/router/index.dart';

class LoginController extends GetxController {
  
  Future<void> login(String username, String password) async {
    try {
      final response = await BaseApiService.dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );
      if (response != null) {
        AppRoutes.offAll(AppRoutes.home);
      } else {
        Get.snackbar('Error', 'Login failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
} 