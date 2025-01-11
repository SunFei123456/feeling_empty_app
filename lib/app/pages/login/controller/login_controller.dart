import 'dart:async';

import 'package:fangkong_xinsheng/app/router/index.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../api/index.dart';
import '../model/login.dart';
import 'package:dio/dio.dart';
import 'package:fangkong_xinsheng/app/core/services/token_service.dart';

class LoginController extends GetxController {
  final qqController = TextEditingController();
  final verificationCodeController = TextEditingController();
  final isLoading = false.obs;
  final countdownSeconds = 0.obs;
  final canSendCode = true.obs; // 是是否可以发送验证码
  Timer? _timer;

  @override
  void onClose() {
    qqController.dispose();
    verificationCodeController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  // 开始倒计时
  void startCountdown() {
    countdownSeconds.value = 60;
    canSendCode.value = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownSeconds.value > 0) {
        countdownSeconds.value--;
      } else {
        timer.cancel();
        canSendCode.value = true;
      }
    });
  }

  Future<void> sendVerificationCode() async {
    final qq = qqController.text.trim();
    if (qq.isEmpty) {
      Get.snackbar('提示', '请输入QQ邮箱');
      return;
    }

    // qq邮箱正则表达式
    final qqRegExp = RegExp(r'^[1-9]\d{4,10}@qq\.com$');
    if (!qqRegExp.hasMatch(qq)) {
      Get.snackbar('提示', '请输入正确的QQ邮箱');
      return;
    }

    try {
      final response = await LoginApiService().sendQqEmailCode(qq);
      
      if (response.success) {  // 检查响应是否成功
        startCountdown();  // 成功后开始倒计时
        Get.snackbar('提示', '验证码已发送');
      } else {
        Get.snackbar('提示', response.message ?? '发送验证码失败');
      }
    } catch (e) {
      print('发送验证码失败: $e');
      Get.snackbar('错误', '发送验证码失败');
    }
  }

  Future<void> login() async {
    final qq = qqController.text.trim();
    final code = verificationCodeController.text.trim();

    if (qq.isEmpty || code.isEmpty) {
      Get.snackbar('提示', '请填写完整信息');
      return;
    }

    isLoading.value = true;
    try {
      final response = await LoginApiService().qqLogin(qq, code);
      
      if (response.success && response.data != null) {
        final loginResponse = response.data!;
        // 保存token和用户信息
        await TokenService().saveToken(loginResponse.token);
        if (loginResponse.user.id != 0) {
          await TokenService().saveUserId(loginResponse.user.id);
        }
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.snackbar('提示', response.message ?? '登录失败');
      }
    } catch (e) {
      print('登录失败: $e');
      if (e is DioException) {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            Get.snackbar('错误', '连接超时，请检查网络');
            break;
          case DioExceptionType.connectionError:
            Get.snackbar('错误', '网络连接错误，请检查网络设置');
            break;
          default:
            Get.snackbar('错误', '登录失败: ${e.message}');
        }
      } else {
        Get.snackbar('错误', '登录失败，请稍后重试');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
