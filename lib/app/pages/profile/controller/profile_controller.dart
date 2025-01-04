import 'dart:io';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/profile/api/user.dart';
import 'package:fangkong_xinsheng/app/pages/profile/model/user.dart';
import 'package:fangkong_xinsheng/app/core/services/upload_service.dart';
import 'package:fangkong_xinsheng/app/pages/square/model/bottle_card.dart';

class ProfileController extends GetxController {
  final _userApi = UserApiService();
  final _uploadService = UploadService();
  final user = Rxn<UserModel>();
  final isLoading = false.obs;
  final publicBottles = <BottleCardModel>[].obs;
  final hasMoreBottles = true.obs;
  final currentPage = 1.obs;
  final pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchUserInfo();
  }

  // 获取用户信息
  Future<void> fetchUserInfo() async {
    try {
      isLoading.value = true;
      final response = await _userApi.getUserInfo();

      if (response.success) {
        user.value = response.data;
        // 获取用户信息成功后再获取漂流瓶
        await fetchPublicBottles(refresh: true);
      } else {
        Get.snackbar('错误', response.message ?? '获取用户信息失败');
      }
    } catch (e) {
      print('Fetch user info error: $e');
      Get.snackbar('错误', '获取用户信息失败');
    } finally {
      isLoading.value = false;
    }
  }

  // 上传头像
  Future<String?> uploadAvatar(File file) async {
    try {
      isLoading.value = true;
      final response = await _uploadService.uploadImage(file.path);
      if (response.success) {
        return response.data;
      }
      Get.snackbar('错误', response.message ?? '上传头像失败');
      return null;
    } catch (e) {
      print('Upload avatar error: $e');
      Get.snackbar('错误', '上传头像失败');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // 更新用户信息
  Future<void> updateUserInfo({
    String? nickname,
    String? avatar,
    int? sex,
  }) async {
    try {
      isLoading.value = true;
      final response = await _userApi.updateUserInfo(
        nickname: nickname,
        avatar: avatar,
        sex: sex,
      );

      if (response.success) {
        await fetchUserInfo(); // 更新成功后重新获取用户信息
        Get.snackbar('成功', '更新用户信息成功');
      } else {
        Get.snackbar('错误', response.message ?? '更新用户信息失败');
      }
    } catch (e) {
      print('Update user info error: $e');
      Get.snackbar('错误', '更新用户信息失败');
    } finally {
      isLoading.value = false;
    }
  }

  // 获取用户公开的漂流瓶
  Future<void> fetchPublicBottles({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 1;
        hasMoreBottles.value = true;
        publicBottles.clear();
      }

      if (!hasMoreBottles.value) return;

      // 确保用户ID存在
      if (user.value?.id == null) {
        print('User ID is null, cannot fetch bottles');
        return;
      }

      final response = await _userApi.getPublicBottles(
        userId: user.value!.id,
        page: currentPage.value,
        pageSize: pageSize,
      );

      print('Fetched public bottles: ${response.data}'); // 添加日志

      if (response.success) {
        final bottles = response.data ?? [];
        if (bottles.isEmpty) {
          hasMoreBottles.value = false;
        } else {
          publicBottles.addAll(bottles);
          currentPage.value++;
        }
      } else {
        Get.snackbar('错误', response.message ?? '获取漂流瓶失败');
      }
    } catch (e) {
      print('Fetch public bottles error: $e');
      Get.snackbar('错误', '获取漂流瓶失败');
    }
  }

  // 刷新漂流瓶列表
  Future<void> refreshBottles() async {
    await fetchPublicBottles(refresh: true);
  }

  // 加载更多漂流瓶
  Future<void> loadMoreBottles() async {
    await fetchPublicBottles();
  }
}
