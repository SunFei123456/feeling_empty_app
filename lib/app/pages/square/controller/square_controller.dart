import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/square/api/index.dart';
import 'package:fangkong_xinsheng/app/core/events/bottle_events.dart';
import 'package:fangkong_xinsheng/app/core/services/event_bus_service.dart';

class SquareController extends GetxController {
  final _squareApi = SquareApiService();
  final bottles = <BottleModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRandomBottles();
    
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

  // 获取随机的漂流瓶
  Future<void> fetchRandomBottles() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;
      final response = await _squareApi.getRandomBottles();

      if (response.success) {
        bottles.value = response.data ?? [];
        if (bottles.isEmpty) {
          Get.snackbar('提示', '暂时没有更多漂流瓶了');
        }
      } else {
        Get.snackbar('错误', response.message ?? '获取漂流瓶失败');
      }
    } catch (e) {
      print('Fetch random bottles error: $e');
      Get.snackbar('错误', '获取漂流瓶失败');
    } finally {
      isLoading.value = false;
    }
  }

  // 更新共振状态并发送事件
  void updateBottleResonateStatus(int bottleId, {required bool isResonated, required int resonates}) {
    EventBusService.to.eventBus.fire(BottleEvent(
      bottleId: bottleId,
      isResonated: isResonated,
      resonates: isResonated ? resonates + 1 : resonates - 1,
    ));
  }

  // 获取瓶子的当前状态
  BottleModel? getBottleStatus(int bottleId) {
    return bottles.firstWhereOrNull((bottle) => bottle.id == bottleId);
  }

  // 更新收藏状态并发送事件
  void updateBottleFavoriteStatus(int bottleId, {required bool isFavorited, required int favorites}) {
    EventBusService.to.eventBus.fire(BottleEvent(
      bottleId: bottleId,
      isFavorited: isFavorited,
      favorites: isFavorited ? favorites + 1 : favorites - 1,
    ));
  }
}
