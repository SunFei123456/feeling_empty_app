import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class TokenService extends GetxService {
  static final TokenService _instance = TokenService._internal();
  factory TokenService() => _instance;
  TokenService._internal();

  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _expKey = 'exp';
  final _storage = GetStorage();

  Future<TokenService> init() async {
    await GetStorage.init();
    return this;
  }

  // 获取 token
  String? getToken() {
    return _storage.read<String>(_tokenKey);
  }

  // 保存 token
  Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  // 清除 token
  Future<void> clearToken() async {
    await _storage.remove(_tokenKey);
  }

  // 检查是否有 token
  bool hasToken() {
    return _storage.hasData(_tokenKey);
  }

  // 保存用户ID
  Future<void> saveUserId(int userId) async {
    await _storage.write(_userIdKey, userId);
  }

  // 保存过期时间
  Future<void> saveExp(int exp) async {
    await _storage.write(_expKey, exp);
  }

  // 获取用户ID
  int? getUserId() {
    return _storage.read<int>(_userIdKey);
  }

  // 获取过期时间
  int? getExp() {
    return _storage.read<int>(_expKey);
  }

  // 清除所有认证信息
  Future<void> clearAuth() async {
    await _storage.remove(_tokenKey);
    await _storage.remove(_userIdKey);
    await _storage.remove(_expKey);
  }
}
