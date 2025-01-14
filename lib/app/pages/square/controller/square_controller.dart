import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/square/api/index.dart';

class SquareController extends GetxController {
  final _squareApi = SquareApiService();
  final bottles = <BottleModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRandomBottles();
  }

  // 获取随机的漂流瓶
  Future<void> fetchRandomBottles() async {
    try {
      if (isLoading.value) return; // 防止重复请求

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

  // 添加更新瓶子共振状态的方法
  void updateBottleResonateStatus(int bottleId, {required bool isResonated, required int resonates}) {
    final index = bottles.indexWhere((bottle) => bottle.id == bottleId);
    if (index != -1) {
      bottles[index].isResonated = isResonated;
      bottles[index].resonates = resonates;
      bottles.refresh();  // 刷新列表触发UI更新
    }
  }

  // 获取瓶子的当前状态
  BottleModel? getBottleStatus(int bottleId) {
    return bottles.firstWhereOrNull((bottle) => bottle.id == bottleId);
  }

  // 更新瓶子的收藏状态
  void updateBottleFavoriteStatus(int bottleId, {required bool isFavorited, required int favorites}) {
    final index = bottles.indexWhere((bottle) => bottle.id == bottleId);
    if (index != -1) {
      bottles[index].isFavorited = isFavorited;
      bottles[index].favorites = favorites;
      bottles.refresh();
    }
  }
}
