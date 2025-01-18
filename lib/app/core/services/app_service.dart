import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/core/services/storage_service.dart';
import 'package:fangkong_xinsheng/app/constants/storage_keys.dart';

/// 应用服务：统一管理主题、语言等应用级配置
class AppService extends GetxService {
  final _storage = Get.find<StorageService>();
  final _currentLocale = const Locale('zh', 'CN').obs;
  final _isDarkMode = false.obs;

  // 是否为深色模式
  bool get isDarkMode => _isDarkMode.value;
  // 当前的语言
  Locale get currentLocale => _currentLocale.value;
  // 当前的主题模式
  ThemeMode get currentThemeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    
    // 监听深色模式变化
    ever(_isDarkMode, (bool isDark) {
      Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
      _storage.setBool(StorageKeys.isDarkMode, isDark);
    });
  }

  Future<void> _loadSettings() async {
    // 加载主题设置
    final savedDarkMode = await _storage.getBool(StorageKeys.isDarkMode);
    if (savedDarkMode != null) {
      _isDarkMode.value = savedDarkMode;
    } else {
      _isDarkMode.value = Get.isPlatformDarkMode; // 默认为跟随系统
    }

    // 加载语言设置
    final languageCode = await _storage.getString(StorageKeys.languageCode) ?? 'zh'; // 默认为中文
    final countryCode = await _storage.getString(StorageKeys.countryCode) ?? 'CN'; // 默认为中国
    _currentLocale.value = Locale(languageCode, countryCode);
  }

  // 切换主题
  Future<void> toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
  }

  // 更新主题模式
  Future<void> updateThemeMode(ThemeMode mode) async {
    _isDarkMode.value = mode == ThemeMode.dark;
  }

  // 切换语言
  Future<void> updateLocale(Locale locale) async {
    await _storage.setString(StorageKeys.languageCode, locale.languageCode);
    await _storage.setString(StorageKeys.countryCode, locale.countryCode ?? '');
    _currentLocale.value = locale;
    Get.updateLocale(locale);
  }

  @override
  Future<AppService> init() async {
    await _loadSettings();
    return this;
  }
}
