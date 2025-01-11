// 创建一个时间处理函数
import 'package:fangkong_xinsheng/app/core/services/token_service.dart';

String formatTime(String timeStr) {
  DateTime dateTime = DateTime.parse(timeStr);
  return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
}

// 是否是当前用户
bool isCurrentUser(int userId) {
  return userId == TokenService().getUserId();
}