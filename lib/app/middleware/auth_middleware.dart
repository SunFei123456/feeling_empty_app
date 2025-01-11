import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/core/services/token_service.dart';
import 'package:fangkong_xinsheng/app/router/index.dart';

// 登录中间件
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final token = TokenService().getToken();
    
    // 如果没有token，并且不是登录页面，才重定向到登录页
    if ((token == null || token.isEmpty) && route != AppRoutes.login) {
      return const RouteSettings(name: AppRoutes.login);
    }
    
    // 如果有token，并且是登录页面，重定向到主页
    if (token != null && token.isNotEmpty && route == AppRoutes.login) {
      return const RouteSettings(name: AppRoutes.home);
    }
    
    // 其他情况不重定向
    return null;
  }
} 