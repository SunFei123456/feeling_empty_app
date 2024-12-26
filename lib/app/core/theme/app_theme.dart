import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    // ... 其他亮色主题配置
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    // ... 其他暗色主题配置
  );
}