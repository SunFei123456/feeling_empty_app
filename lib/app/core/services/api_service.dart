import 'package:get/get.dart';
import '../http/dio_client.dart';
import '../utils/web_url.dart';

/// API 服务基类
class BaseApiService extends GetxService {
  static final DioClient dio = DioClient(
    baseUrl: WebUrls.host,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  );
}

// /// 学习模块 API
// class StudyApiService extends BaseApiService {
//   // 获取课程列表
//   Future<ApiResponse<List<Course>>> getCourseList() async {
//     final response = await dio.get<Map<String, dynamic>>('/courses');
//     return ApiResponse.fromJson(
//       response!,
//       (json) => (json as List).map((e) => Course.fromJson(e)).toList(),
//     );
//   }
// }

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