import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:fangkong_xinsheng/app/core/http/interceptors.dart';

/// API 服务基类
class BaseApiService extends GetxService {
  static String api = dotenv.get('Dev_Api');
  static final Dio dio = Dio(BaseOptions(
    baseUrl: 'http://$api/api/v1',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 5),
  ))
    ..interceptors.addAll([
      TokenInterceptor(),
      LogInterceptor(responseBody: true, requestBody: true),
    ]);
}
