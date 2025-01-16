/// API 端点常量
class ApiEndpoints {
  // 基础 URL
  static const String baseUrl = '/api/v1';
  
  // 用户相关
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String userProfile = '/users/profile';
  
  // 漂流瓶相关
  static const String bottles = '/bottles';
  static const String hotBottles = '/bottles/hot';
  static const String userBottles = '/bottles/user';
  
  // 其他功能
  static const String uploadToken = '/cos/upload-token';
  static const String topics = '/topics';
  static const String oceans = '/oceans';
}