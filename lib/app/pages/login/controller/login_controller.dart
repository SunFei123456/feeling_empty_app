import 'dart:async';

import 'package:fangkong_xinsheng/app/router/index.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../api/index.dart';
import '../model/login.dart';
import 'package:dio/dio.dart';
import 'package:fangkong_xinsheng/app/core/services/token_service.dart';

class LoginController extends GetxController {
  final accountController = TextEditingController();
  final passwordController = TextEditingController();
  final _loginApi = LoginApiService();
  final isLoading = false.obs;
  final _tokenService = TokenService();

  @override
  void onClose() {
    accountController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (accountController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', '请输入账号和密码');
      return;
    }

    try {
      isLoading.value = true;
      final loginModel = LoginModel(
        account: accountController.text,
        password: passwordController.text,
      );
      final response = await _loginApi.login(loginModel);

      if (response.success) {
        final loginResponse = response.data as LoginResponse;
        await _tokenService.saveToken(loginResponse.token);
        if (loginResponse.user?.id != null) {
          await _tokenService.saveUserId(loginResponse.user!.id);
        }
        print("登录成功 -----> token: ${loginResponse.token}");
        Get.offAllNamed(AppRoutes.home);
      } else {
        print("登录失败 -----> code: ${response.code}, message: ${response.message}");
        Get.snackbar('Error', response.message ?? '登录失败,请检查账号和密码');
      }
    } catch (e, stackTrace) {
      print("登录异常 -----> $e\n$stackTrace");
      if (e is DioException) {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            Get.snackbar('Error', '连接超时，请检查网络');
            break;
          case DioExceptionType.connectionError:
            Get.snackbar('Error', '网络连接错误，请检查网络设置');
            break;
          default:
            Get.snackbar('Error', '网络请求失败: ${e.message}');
        }
      } else {
        Get.snackbar('Error', e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  // 初始化默认凭证
  void initDefaultCredentials() {
    accountController.text = '2770894498@qq.com';
    passwordController.text = 'sunfei123';
  }
}
