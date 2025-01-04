import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:fangkong_xinsheng/app/core/http/interceptors.dart';

/// API 服务基类
class BaseApiService extends GetxService {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: 'http://8.152.194.158:8080/api/v1',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 5),
  ))..interceptors.addAll([
      TokenInterceptor(),
      LogInterceptor(responseBody: true, requestBody: true),
    ]);
}



// /// 老师模块 API
// class TeacherApiService extends BaseApiService {
//   // 获取老师列表
//   Future<ApiResponse<List<Teacher>>> getTeacherList() async {
//     final response = await dio.get<Map<String, dynamic>>('/teachers');
//     return ApiResponse.fromJson(
//       response!,
//       (json) => (json as List).map((e) => Teacher.fromJson(e)).toList(),
//     );
//   }
// } 