import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/views/api/view_history_api.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/view_history.dart';

class ViewHistoryController extends GetxController {
  final ViewHistoryApiService _apiService = ViewHistoryApiService();

  final RxList<BottleModel> historyItems = <BottleModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalItems = 0.obs;
  final int pageSize = 10;
  bool hasMore = true;

  @override
  void onInit() {
    super.onInit();
    loadViewHistory();
  }

  @override
  void onReady() {
    super.onReady();
    print('ViewHistoryController onReady');
  }

  Future<void> loadViewHistory({bool refresh = false}) async {
    print('Loading history... refresh: $refresh');
    if (refresh) {
      currentPage.value = 1;
      historyItems.clear();
      hasMore = true;
    }

    if (isLoading.value || !hasMore) return;

    try {
      isLoading.value = true;
      final response = await _apiService.getViewHistory(
        page: currentPage.value,
        pageSize: pageSize,
      );

      if (response.data != null) {
        if (response.data!.data.isEmpty) {
          hasMore = false;
          return;
        }

        final newItems = response.data!.data.toList();
        historyItems.addAll(newItems);
        totalItems.value = response.data!.total;
        currentPage.value++;

        if (historyItems.length >= response.data!.total) {
          hasMore = false;
        }
      }
    } catch (e) {
      print('Load view history error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 删除指定的浏览记录
  Future<void> deleteViewHistory(int id) async {
    final response = await _apiService.deleteViewHistory(id);
    if (response.success) {
      historyItems.removeWhere((item) => item.id == id);
    }
  }

  // 清空历史记录
  Future<void> clearHistory() async {
    // TODO: Implement clear history functionality
    try {
      await _apiService.clearViewHistory();
      historyItems.clear();
      totalItems.value = 0;
      currentPage.value = 1;
      hasMore = true;
      Get.snackbar('提示', '历史记录已清空');
    } catch (e) {
      print('Clear history error: $e');
      Get.snackbar('错误', '清空历史记录失败');
    }
  }

  Future<void> createViewHistory(int id) async {
    final response = await _apiService.createViewHistory(id);
    if (response.success) {
      // 刷新历史记录
      loadViewHistory(refresh: true);
    }
  }
}
