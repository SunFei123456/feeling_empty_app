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
}
