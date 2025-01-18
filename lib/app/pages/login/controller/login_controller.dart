import 'dart:async';

import 'package:fangkong_xinsheng/app/router/index.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../api/index.dart';
import 'package:fangkong_xinsheng/app/core/services/token_service.dart';

class LoginController extends GetxController {
  final qqController = TextEditingController();
  final verificationCodeController = TextEditingController();
  final isLoading = false.obs;
  final countdownSeconds = 0.obs;
  final canSendCode = true.obs;
  Timer? _timer;
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    _isDisposed = false;
  }

  @override
  void onClose() {
    _isDisposed = true;
    _timer?.cancel();
    if (!_isDisposed) {
      qqController.dispose();
      verificationCodeController.dispose();
    }
    super.onClose();
  }

  Future<void> login() async {
    if (_isDisposed) return;

    final qq = qqController.text.trim();
    final code = verificationCodeController.text.trim();

    if (qq.isEmpty) {
      Get.snackbar('提示', '请输入邮箱');
      return;
    }

    if (code.isEmpty) {
      Get.snackbar('提示', '请输入验证码');
      return;
    }

    try {
      isLoading.value = true;
      final response = await LoginApiService().qqLogin(qq, code);

      if (_isDisposed) {
        isLoading.value = false;
        return;
      }

      if (response.success && response.data != null) {
        final loginResponse = response.data!;
        isLoading.value = false;

        // 存储token + 用户id + 过期时间
        await Future.wait([
          TokenService().saveToken(loginResponse.token),
          TokenService().saveUserId(loginResponse.user.id),
          TokenService().saveExp(loginResponse.exp),
        ]);

        Get.offAllNamed(AppRoutes.home);
      } else {
        isLoading.value = false;

        if (!_isDisposed) {
          verificationCodeController.clear();
        }
        Get.snackbar(
          '提示',
          response.message ?? '验证码错误，请重新输入',
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('登录失败: $e');
      isLoading.value = false;
      if (_isDisposed) return;
      Get.snackbar('提示', '登录失败，请稍后重试');
    }
  }

  Future<void> sendVerificationCode() async {
    if (_isDisposed) return;

    final qq = qqController.text.trim();
    if (qq.isEmpty) {
      Get.snackbar('提示', '请输入QQ邮箱');
      return;
    }

    final qqRegExp = RegExp(r'^[1-9]\d{4,10}@qq\.com$');
    if (!qqRegExp.hasMatch(qq)) {
      Get.snackbar('提示', '请输入正确的QQ邮箱');
      return;
    }

    try {
      final response = await LoginApiService().sendQqEmailCode(qq);

      if (_isDisposed) return;

      if (response.success) {
        startCountdown();
        Get.snackbar('提示', '验证码已发送');
      } else {
        Get.snackbar('提示', response.message ?? '发送验证码失败');
      }
    } catch (e) {
      print('发送验证码失败: $e');
      if (!_isDisposed) {
        Get.snackbar('提示', '发送验证码失败');
      }
    }
  }

  void startCountdown() {
    if (_isDisposed) return;

    countdownSeconds.value = 60;
    canSendCode.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }
      if (countdownSeconds.value > 0) {
        countdownSeconds.value--;
      } else {
        timer.cancel();
        canSendCode.value = true;
      }
    });
  }
}
