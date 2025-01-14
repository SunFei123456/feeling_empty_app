import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:fangkong_xinsheng/app/router/index.dart';
import 'controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async {
              if (controller.isLoading.value) {
                return false;
              }
              return true;
            },
            child: Stack(
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

                        // QQ号输入框
                        _buildQQInput(controller),
                        const SizedBox(height: 20),

                        // 验证码输入框
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildQQInput(LoginController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.qqController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '请输入QQ邮箱',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.person_outline, color: Colors.blue[400]),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),
          Obx(() => Container(
                height: 56,
                margin: const EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: controller.canSendCode.value
                      ? controller.sendVerificationCode
                      : null,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    controller.countdownSeconds.value > 0
                        ? '${controller.countdownSeconds.value}s'
                        : '发送验证码',
                    style: TextStyle(
                      color: controller.canSendCode.value
                          ? Colors.blue[600]
                          : Colors.grey[400],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildVerificationCodeInput(LoginController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller.verificationCodeController,
        keyboardType: TextInputType.number,
        maxLength: 6,
        decoration: InputDecoration(
          hintText: '请输入验证码',
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.lock_outline, color: Colors.blue[400]),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          counterText: "",
        ),
      ),
    );
  }

  Widget _buildLoginButton(LoginController controller) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.login,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'login'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          )),
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
            _buildSocialLoginButton(Icons.wechat, Colors.green, '微信登录'),
            const SizedBox(width: 20),
            _buildSocialLoginButton(Icons.hub, Colors.black, 'GitHub登录'),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialLoginButton(IconData icon, Color color, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () {},
            child: Icon(icon, color: color, size: 28),
          ),
        ),
      ),
    );
  }
}
