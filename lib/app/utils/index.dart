// 创建一个时间处理函数
import 'dart:ui';

import 'package:fangkong_xinsheng/app/core/services/token_service.dart';
import 'package:flutter/material.dart';

String formatTime(String timeStr) {
  DateTime dateTime = DateTime.parse(timeStr);
  return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
}

// 格式化时间 只显示年月日
String formatTimeOnlyDate(String timeStr) {
  DateTime dateTime = DateTime.parse(timeStr);
  return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
}

// 是否是当前用户
bool isCurrentUser(int userId) {
  return userId == TokenService().getUserId();
}

// 获取两人的关注状态 根据 string 进行转换 自己查看别人主页的显示(角度)
String getFollowStatusText(String status) {
  switch (status) {
    case 'mutual_following':
      return '互相关注';
    case 'not_following':
      return '关注';
    case 'followed':
      return '回关';
    case 'following':
      return '已关注';
    default:
      return '未知';
  }
}

// 根据不同状态返回不同的颜色
Color getFollowStatusColor(String status) {
  switch (status) {
    case 'mutual_following':
      return Colors.blue;
    case 'followed':
      return Colors.redAccent;
    case 'following':
      return Colors.orange;
    case 'not_following':
      return Colors.redAccent;
    default:
      return Colors.grey;
  }
}
