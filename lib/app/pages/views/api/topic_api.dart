import 'dart:async';

import 'package:fangkong_xinsheng/app/core/http/api_response.dart';
import 'package:fangkong_xinsheng/app/core/services/api_service.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/topic.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/topic_detail.dart';

class TopicApiService extends BaseApiService {
  // 获取热门话题(横向列表滚动)
  Future<ApiResponse<List<Topic>>> getHotTopics(int limit) async {
    try {
      final response = await BaseApiService.dio.get('/topics/hot?limit=$limit');
      final responseData = response.data as Map<String, dynamic>;

      return ApiResponse<List<Topic>>(
        code: responseData['code'] as int,
        message: responseData['message'] as String,
        data: (responseData['data'] as List).map((item) => Topic.fromJson(item as Map<String, dynamic>)).toList(),
        success: responseData['code'] == 200,
      );
    } catch (e) {
      print('Get hot topics error: $e');
      rethrow;
    }
  }

  // 获取话题详情(信息)
  Future<ApiResponse<TopicDetail>> getTopicDetail(int topicId) async {
    try {
      final response = await BaseApiService.dio.get('/topics/$topicId');
      final responseData = response.data as Map<String, dynamic>;

      return ApiResponse<TopicDetail>(
        code: responseData['code'] as int,
        message: responseData['message'] as String,
        data: TopicDetail.fromJson(responseData['data'] as Map<String, dynamic>),
        success: responseData['code'] == 200,
      );
    } catch (e) {
      print('Get topic detail error: $e');
      rethrow;
    }
  }

  // 获取指定话题下的瓶子列表, 接收参数 sort :  new or hot
  Future<ApiResponse<List<BottleModel>>> getBottlesByTopic(int topicId, String sort) async {
    try {
      final response = await BaseApiService.dio.get('/topics/$topicId/bottles', queryParameters: {'sort': sort});
      final responseData = response.data as Map<String, dynamic>;

      return ApiResponse<List<BottleModel>>(
        code: responseData['code'] as int,
        message: responseData['message'] as String,
        data: (responseData['data'] as List).map((item) => BottleModel.fromJson(item as Map<String, dynamic>)).toList(),
        success: responseData['code'] == 200,
      );
    } catch (e) {
      print('Get bottles by topic error: $e');
      rethrow;
    }
  }

  // 创建一个话题(面向用户) type: 1 --> 用户自发创建, 0 : 系统预设
  FutureOr<String> createTopic(String topicName, String desc, String bgImage) async {
    try {
      final response = await BaseApiService.dio.post(
        '/topics',
        data: {
          'title': topicName,
          'desc': desc,
          'bg_image': bgImage,
          'type': 1,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['code'] == 200 && responseData['message'] == 'success') {
        return "success";
      }
      return "failed";
    } catch (e) {
      print('Create topic error: $e');
      return "error";
    }
  }

  // 搜索话题
  Future<ApiResponse<List<Topic>>> searchTopics(String keyword) async {
    try {
      final response = await BaseApiService.dio.get('/topics/search', queryParameters: {'keyword': keyword});
      final responseData = response.data as Map<String, dynamic>;

      return ApiResponse<List<Topic>>(
        code: responseData['code'] as int,
        message: responseData['message'] as String,
        data: (responseData['data'] as List).map((item) => Topic.fromJson(item as Map<String, dynamic>)).toList(),
        success: responseData['code'] == 200,
      );
    } catch (e) {
      print('Search topics error: $e');
      rethrow;
    }
  }

  // 增加xx话题的浏览量
  Future<ApiResponse> increaseTopicViews(int topicId) async {
    final response = await BaseApiService.dio.post('/topics/views/$topicId');
    final responseData = response.data as Map<String, dynamic>;
    return ApiResponse(
      code: responseData['code'] as int,
      message: responseData['message'] as String,
      success: responseData['code'] == 200,
    );
  }
}
