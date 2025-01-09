
import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:fangkong_xinsheng/app/pages/square/views/bottle_card_detail.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/topic_detail.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/views/api/topic_api.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/topic.dart';
import 'package:flutter/widgets.dart';

class TopicController extends GetxController {
  final TopicApiService _apiService = TopicApiService(); // 话题接口服务
  final RxList<Topic> hotTopics = <Topic>[].obs; // 热门话题(横向列表滚动)
  final RxBool isLoading = false.obs;
  final Rx<TopicDetail> topicDetail = TopicDetail().obs; // 话题详情(话题的相关详细信息)
  final RxBool isDetailLoading = false.obs;

  final RxList<BottleModel> bottles = <BottleModel>[].obs; // 瓶子列表

  @override
  void onInit() {
    super.onInit();
    loadHotTopics();
  }


  // 加载热门话题
  Future<void> loadHotTopics() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getHotTopics();
      if (response.success && response.data != null) {
        hotTopics.value = response.data!;
      }
    } catch (e) {
      print('Load hot topics error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 加载话题详情
  Future<void> loadTopicDetail(int topicId) async {
    try {
      isDetailLoading.value = true;
      final response = await _apiService.getTopicDetail(topicId);
      if (response.success && response.data != null) {
        topicDetail.value = response.data!;
      }
    } catch (e) {
      print('Load topic detail error: $e');
    } finally {
      isDetailLoading.value = false;
    }
  }

  // 初始化话题详情
  void initTopicDetail(int topicId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadTopicDetail(topicId);
      loadTopicBottles(topicId);
    });
  }

  // 加载话题下的瓶子列表
  Future<void> loadTopicBottles(int topicId, {bool isHot = false}) async {
    try {
      isLoading.value = true;
      final response = await _apiService.getBottlesByTopic(topicId, isHot ? 'hot' : 'new');
      if (response.success && response.data != null) {
        bottles.value = response.data!;
      }
    } catch (e) {
      print('Load topic bottles error: $e');
    } finally {
      isLoading.value = false;
    }
  }

}
