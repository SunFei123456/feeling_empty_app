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
    return ApiResponse<T>(
      success: json['success'] as bool,
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