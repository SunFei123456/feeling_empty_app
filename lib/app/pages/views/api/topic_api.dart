import 'package:fangkong_xinsheng/app/core/http/api_response.dart';
import 'package:fangkong_xinsheng/app/core/services/api_service.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/topic.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/topic_detail.dart';

class TopicApiService extends BaseApiService {
  // 获取热门话题(横向列表滚动)
  Future<ApiResponse<List<Topic>>> getHotTopics() async {
    try {
      final response = await BaseApiService.dio.get('/topics/hot');
      final responseData = response.data as Map<String, dynamic>;

      return ApiResponse<List<Topic>>(
        code: responseData['code'] as int,
        message: responseData['message'] as String,
        data: (responseData['data'] as List)
            .map((item) => Topic.fromJson(item as Map<String, dynamic>))
            .toList(),
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
        data:
            TopicDetail.fromJson(responseData['data'] as Map<String, dynamic>),
        success: responseData['code'] == 200,
      );
    } catch (e) {
      print('Get topic detail error: $e');
      rethrow;
    }
  }

  // 获取指定话题下的瓶子列表, 接收参数 sort :  new or hot
  Future<ApiResponse<List<BottleModel>>> getBottlesByTopic(
      int topicId, String sort) async {
    try {
      final response = await BaseApiService.dio
          .get('/topics/$topicId/bottles', queryParameters: {'sort': sort});
      final responseData = response.data as Map<String, dynamic>;

      return ApiResponse<List<BottleModel>>(
        code: responseData['code'] as int,
        message: responseData['message'] as String,
        data: (responseData['data'] as List)
            .map((item) => BottleModel.fromJson(item as Map<String, dynamic>))
            .toList(),
        success: responseData['code'] == 200,
      );
    } catch (e) {
      print('Get bottles by topic error: $e');
      rethrow;
    }
  }

  // 创建一个话题(面向用户) type: 1 --> 用户自发创建, 0 : 系统预设
  Future<ApiResponse> createTopic(String topicName) async {
    try {
      final response = await BaseApiService.dio.post(
        '/topics', 
        data: {
          'title': topicName,
          'desc': '',
          'type': 1,
        },
      );
      
      final responseData = response.data as Map<String, dynamic>;

      return ApiResponse(
        code: responseData['code'] as int,
        message: responseData['message'] as String,
        success: responseData['code'] == 200,
        data: responseData['data'] as Map<String, dynamic>,
      );
    } catch (e) {
      print('Create topic error: $e');
      return ApiResponse(
        code: 400,
        message: e.toString(),
        success: false,
        data: null,
      );
    }
  }
  
}
