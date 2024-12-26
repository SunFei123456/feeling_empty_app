import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/app_service.dart';

class SettingController extends GetxController {
  final _appService = Get.find<AppService>();
  
  // 当前主题模式
  bool get isDarkMode => _appService.isDarkMode;
  
  // 当前语言
  Locale get currentLocale => _appService.currentLocale;
  
  // 支持的语言列表
  final List<Map<String, dynamic>> languages = [
    {'name': '简体中文', 'locale': const Locale('zh', 'CN')},
    {'name': 'English', 'locale': const Locale('en', 'US')},
  ];

  // 切换主题
  void toggleTheme() {
    _appService.toggleTheme();
    update();
  }

  // 切换语言
  void updateLocale(Locale locale) {
    _appService.updateLocale(locale);
    update();
  }
} 