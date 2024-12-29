import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:fangkong_xinsheng/app/router/index.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (controller) {
          return Stack(
            children: [
              // 背景渐变
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).brightness == Brightness.light
                          ? const Color(0xFFE3F2FD)
                          : const Color(0xFF1A237E),
                      Theme.of(context).brightness == Brightness.light
                          ? const Color(0xFFBBDEFB)
                          : const Color(0xFF0D47A1),
                    ],
                  ),
                ),
              ),

              // 主要内容
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      // 欢迎标题
                      Text(
                        'welcome'.tr,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'login_subtitle'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(height: 60),

                      // 手机号输入框
                      _buildPhoneInput(controller),
                      const SizedBox(height: 20),

                      // 验证码输入框和获取验证码按钮
                      _buildVerificationCodeInput(controller),
                      const SizedBox(height: 40),

                      // 登录按钮
                      _buildLoginButton(controller),
                      const SizedBox(height: 20),

                      // 其他登录方式
                      _buildOtherLoginMethods(context),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPhoneInput(LoginController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller.phoneController,
        keyboardType: TextInputType.phone,
        maxLength: 11,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          hintText: 'phone_hint'.tr,
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.phone_android),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildVerificationCodeInput(LoginController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.codeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'verification_code_hint'.tr,
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.lock_outline),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Obx(() => TextButton(
                  onPressed: controller.canGetCode.value
                      ? controller.getVerificationCode
                      : null,
                  child: Text(
                    controller.countdownStr.value,
                    style: const TextStyle(fontSize: 14),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(LoginController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.login,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'login'.tr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildOtherLoginMethods(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300])),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'other_login_methods'.tr,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey[300])),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialLoginButton(Icons.wechat, Colors.green),
            const SizedBox(width: 20),
            _buildSocialLoginButton(Icons.facebook, Colors.blue),
            const SizedBox(width: 20),
            _buildSocialLoginButton(Icons.apple, Colors.black),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialLoginButton(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: () {},
      ),
    );
  }
}

class LoginController extends GetxController {
  final phoneController = TextEditingController(text: 'root');
  final codeController = TextEditingController(text: '123456');

  final countdownStr = 'get_code'.tr.obs;
  final canGetCode = true.obs;
  Timer? _timer;
  int _countdown = 60;

  @override
  void onClose() {
    phoneController.dispose();
    codeController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void getVerificationCode() {
    if (!canGetCode.value) return;
    if (phoneController.text != 'root') {
      Get.snackbar('error'.tr, 'phone_invalid'.tr);
      return;
    }

    canGetCode.value = false;
    _countdown = 60;
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown <= 0) {
        timer.cancel();
        countdownStr.value = 'get_code'.tr;
        canGetCode.value = true;
      } else {
        _countdown--;
        countdownStr.value = '${_countdown}s';
      }
    });
  }

  void login() {
    final phone = phoneController.text;
    final code = codeController.text;

    if (phone != 'root' || code != '123456') {
      Get.snackbar(
        'error'.tr,
        'invalid_credentials'.tr,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    Get.changeThemeMode(ThemeMode.light);
    Get.offAllNamed(AppRoutes.home);
  }
}
