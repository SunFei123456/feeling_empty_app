import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:fangkong_xinsheng/app/pages/square/views/bottle_card_detail.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/topic_detail.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/views/api/topic_api.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/topic.dart';
import 'package:flutter/widgets.dart';
import 'package:fangkong_xinsheng/app/core/events/bottle_events.dart';
import 'package:fangkong_xinsheng/app/core/services/event_bus_service.dart';

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
    
    // 监听瓶子状态更新事件
    EventBusService.to.eventBus.on<BottleEvent>().listen((event) {
      final index = bottles.indexWhere((b) => b.id == event.bottleId);
      if (index != -1) {
        if (event.isResonated != null) bottles[index].isResonated = event.isResonated!;
        if (event.resonates != null) bottles[index].resonates = event.resonates!;
        if (event.isFavorited != null) bottles[index].isFavorited = event.isFavorited!;
        if (event.favorites != null) bottles[index].favorites = event.favorites!;
        bottles.refresh();
      }
    });
  }

  @override
  void onClose() {
    EventBusService.to.eventBus.destroy();
    super.onClose();
  }

  // 增加xx话题的浏览量
  Future<void> addTopicView(int topicId) async {
    try {
      final response = await _apiService.increaseTopicViews(topicId);
      if (response.success) {
        print('该$topicId话题的浏览量已增加');
      }
    } catch (e) {
      print('Add topic view error: $e');
    }
  }
  // 加载热门话题
  Future<void> loadHotTopics() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getHotTopics(5);
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
      }else{
        print('Load topic bottles error: ${response.message}');
        bottles.value = [];
      }
    } catch (e) {
      print('Load topic bottles error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateBottleFavoriteStatus(int bottleId,
      {required bool isFavorited, required int favorites}) {
    final index = bottles.indexWhere((bottle) => bottle.id == bottleId);
    if (index != -1) {
      final bottle = bottles[index];
      bottle.isFavorited = isFavorited;
      bottle.favorites = favorites;
      bottles.refresh();
    }
  }

  // 更新瓶子状态并发送事件
  void updateBottleStatus(int bottleId, {
    bool? isResonated,
    int? resonates,
    bool? isFavorited,
    int? favorites,
  }) {
    EventBusService.to.eventBus.fire(BottleEvent(
      bottleId: bottleId,
      isResonated: isResonated,
      resonates: resonates,
      isFavorited: isFavorited,
      favorites: favorites,
    ));
  }

  // 清理话题详情数据
  void clearTopicDetail() {
    topicDetail.value = TopicDetail(); // 重置为空的话题模型
    bottles.clear(); // 清空瓶子列表
    isDetailLoading.value = true; // 重置加载状态
  }
}
