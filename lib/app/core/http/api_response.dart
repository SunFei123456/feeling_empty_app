/// API 响应格式
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? code;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.code,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJson) {
    // 根据 code 判断是否成功，200 表示成功
    final isSuccess = json['code'] == 200;
    
    return ApiResponse<T>(
      success: isSuccess,
      message: json['message'] as String?,
      code: json['code'] as int?,
      data: json['data'] == null ? null : fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson(dynamic Function(T?) toJson) {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data == null ? null : toJson(data),
    };
  }
} 