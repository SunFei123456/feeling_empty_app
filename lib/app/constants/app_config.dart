/// 应用配置常量
class AppConfig {
  // 应用信息
  static const String appName = '放空心声';
  static const String appVersion = '1.0.0';
  
  // 网络配置
  static const int connectTimeout = 5000;
  static const int receiveTimeout = 10000;
  static const int sendTimeout = 5000;
  
  // 分页配置
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;
  
  // 缓存配置
  static const Duration cacheMaxAge = Duration(days: 7);
  static const int maxCacheSize = 50 * 1024 * 1024; // 50MB
} 