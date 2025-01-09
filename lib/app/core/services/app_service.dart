import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/core/services/storage_service.dart';

class AppService extends GetxService {
  final _storage = Get.find<StorageService>();
  final _currentLocale = const Locale('en', 'US').obs;
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;
  Locale get currentLocale => _currentLocale.value;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // 加载主题设置
    _isDarkMode.value = await _storage.getBool(StorageKeys.isDarkMode) ?? false;

    // 加载语言设置
    final languageCode =
        await _storage.getString(StorageKeys.languageCode) ?? 'en';
    final countryCode =
        await _storage.getString(StorageKeys.countryCode) ?? 'US';
    _currentLocale.value = Locale(languageCode, countryCode);
  }

  // 主题切换
  Future<void> toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
    await _storage.setBool(StorageKeys.isDarkMode, _isDarkMode.value);
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  // 语言切换
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
