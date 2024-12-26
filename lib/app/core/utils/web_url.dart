

import 'package:flutter/foundation.dart';

class WebUrls {
  static const bool useDevEnv = true;
  static const String domain = (kDebugMode && useDevEnv) ? "musk.weallwitness.com" : "dx.weallwitness.com";
  static const String host = 'https://$domain';
  // static const String wsHost = 'wss://$domain/cable';

  static String path(String path) {
    return join(host, path);
  }

  static String join(String host, String path) {
    String normalizedHost = host.endsWith('/') ? host.substring(0, host.length - 1) : host;
    String normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    return '$normalizedHost/$normalizedPath';
  }
}
