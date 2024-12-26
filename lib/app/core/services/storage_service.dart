import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 存储键名管理
class StorageKeys {
  static const isDarkMode = 'isDarkMode';
  static const languageCode = 'languageCode';
  static const countryCode = 'countryCode';
}

/// 本地存储服务
class StorageService extends GetxService {
  late final SharedPreferences _prefs;
  
  /// 初始化存储服务
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  /// 获取布尔值
  Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  /// 获取字符串
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  /// 获取整型值
  Future<int?> getInt(String key) async {
    return _prefs.getInt(key);
  }

  /// 获取双精度值
  Future<double?> getDouble(String key) async {
    return _prefs.getDouble(key);
  }

  /// 获取字符串列表
  Future<List<String>?> getStringList(String key) async {
    return _prefs.getStringList(key);
  }

  /// 保存布尔值
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  /// 保存字符串
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  /// 保存整型值
  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  /// 保存双精度值
  Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  /// 保存字符串列表
  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  /// 是否包含某个键
  bool hasKey(String key) {
    return _prefs.containsKey(key);
  }

  /// 删除指定键值对
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  /// 清空所有数据
  Future<bool> clear() async {
    return await _prefs.clear();
  }
}
