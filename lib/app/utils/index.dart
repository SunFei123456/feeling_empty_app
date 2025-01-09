// 创建一个时间处理函数
String formatTime(String timeStr) {
  DateTime dateTime = DateTime.parse(timeStr);
  return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
}