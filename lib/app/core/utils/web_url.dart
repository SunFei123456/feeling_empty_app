class WebUrls {
  static const bool useDevEnv = true;
  static const String localDomain = "8.152.194.158:8080";
  static const String remoteDomain = "dx.weallwitness.com";
  static const String domain = useDevEnv ? localDomain : remoteDomain;
  static const String host = 'http://$domain/api/v1';
  // static const String wsHost = 'wss://$domain/cable';

  static String path(String path) {
    return join(host, path);
  }

  static String join(String host, String path) {
    String normalizedHost =
        host.endsWith('/') ? host.substring(0, host.length - 1) : host;
    String normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    return '$normalizedHost/$normalizedPath';
  }
}
