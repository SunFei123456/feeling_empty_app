import 'package:fangkong_xinsheng/app/pages/bottle/api/index.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class BottleController extends GetxController {
  final _apiService = BottleApiService();
  final RxList<BottleModel> hotBottles = <BottleModel>[].obs;
  final RxBool isLoadingHotBottles = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 移除这里的默认加载，让页面来控制初始加载
    // loadWeekHotBottles(); // 删除这行
  }

  // 加载24小时热门
  Future<void> loadDayHotBottles() async {
    if (isLoadingHotBottles.value) return;

    try {
      isLoadingHotBottles.value = true;
      final response = await _apiService.getHotBottles(10, 1, timeRange: 'day');
      if (response.success && response.data != null) {
        hotBottles.assignAll(response.data!.bottles);
      }
    } finally {
      isLoadingHotBottles.value = false;
    }
  }

  // 加载本周热门
  Future<void> loadWeekHotBottles() async {
    if (isLoadingHotBottles.value) return;

    try {
      isLoadingHotBottles.value = true;
      final response =
          await _apiService.getHotBottles(10, 1, timeRange: 'week');
      if (response.success && response.data != null) {
        hotBottles.assignAll(response.data!.bottles);
      }
    } finally {
      isLoadingHotBottles.value = false;
    }
  }

  // 加载本月热门
  Future<void> loadMonthHotBottles() async {
    if (isLoadingHotBottles.value) return;

    try {
      isLoadingHotBottles.value = true;
      final response =
          await _apiService.getHotBottles(10, 1, timeRange: 'month');
      if (response.success && response.data != null) {
        hotBottles.assignAll(response.data!.bottles);
      }
    } finally {
      isLoadingHotBottles.value = false;
    }
  }
}
