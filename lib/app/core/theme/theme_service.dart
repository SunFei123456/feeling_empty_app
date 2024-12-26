import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_study/app/core/services/storage_service.dart';

/// 主题服务
class ThemeService extends GetxService {
  final _storage = Get.find<StorageService>();
  
  /// 获取当前主题模式
  Future<ThemeMode> getThemeMode() async {
    final isDark = await _storage.getBool(StorageKeys.isDarkMode) ?? false;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  /// 切换主题模式
  Future<void> switchTheme() async {
    final isDark = Get.isDarkMode;
    Get.changeThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
    await _storage.setBool(StorageKeys.isDarkMode, !isDark);
  }

  /// 是否是暗黑模式
  Future<bool> isDarkMode() async {
    return await _storage.getBool(StorageKeys.isDarkMode) ?? false;
  }

  /// 更新主题模式
  Future<void> updateThemeMode(ThemeMode mode) async {
    Get.changeThemeMode(mode);
    await _storage.setBool(StorageKeys.isDarkMode, mode == ThemeMode.dark);
  }
}
