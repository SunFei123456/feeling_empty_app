import 'dart:io';
import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/profile/api/user.dart';
import 'package:fangkong_xinsheng/app/pages/profile/model/user.dart';
import 'package:fangkong_xinsheng/app/core/services/upload_service.dart';

class ProfileController extends GetxController {
  final int? userId;

  ProfileController({this.userId});

  final _userApi = UserApiService();
  final _uploadService = UploadService();
  final user = Rxn<UserModel>();
  final isLoading = false.obs;
  final isLoadingPrivate = false.obs;
  final publicBottles = <BottleModel>[].obs;
  final privateBottles = <BottleModel>[].obs;
  final hasMoreBottles = true.obs;
  final currentPage = 1.obs;
  final pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    if (userId != null) {
      loadUserProfile(userId!);
    } else {
      loadCurrentUserProfile();
    }

    // 获取用户信息成功后再获取漂流瓶
    ever(user, (value) {
      if (value != null) {
        fetchPublicBottles(refresh: true);
        fetchPrivateBottles(refresh: true);
      }
    });
  }

  Future<void> loadUserProfile(int userId) async {
    // 加载指定用户资料的逻辑
    getUserInfoByUid(userId);
  }

  Future<void> loadCurrentUserProfile() async {
    // 加载当前用户资料的逻辑
    fetchUserInfo();
  }

  // 根据uid 获取用户信息
  Future<void> getUserInfoByUid(int uid) async {
    try {
      isLoading.value = true;
      final response = await _userApi.getUserInfoByUid(uid);

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
        // 直接更新本地用户数据
        if (user.value != null) {
          user.value = user.value!.copyWith(
            nickname: nickname ?? user.value!.nickname,
            avatar: avatar ?? user.value!.avatar,
            sex: sex ?? user.value!.sex,
          );
        }
        Get.snackbar('成功', '更新用户信息成功');
      } else {
        Get.snackbar('错误', response.message ?? '更新用户信息失败');
        throw Exception(response.message);
      }
    } catch (e) {
      print('Update user info error: $e');
      Get.snackbar('错误', '更新用户信息失败');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // 刷新用户信息
  Future<void> refreshUserInfo() async {
    if (userId != null) {
      await loadUserProfile(userId!);
    } else {
      await loadCurrentUserProfile();
    }
    // 同时刷新漂流瓶列表
    await refreshBottles();
    await refreshPrivateBottles();
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

      final response = await _userApi.getBottles(
        userId: user.value!.id,
        page: 1,
        pageSize: 20,
        isPublic: true,
      );

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

  // 获取私密漂流瓶
  Future<void> fetchPrivateBottles({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 1;
        hasMoreBottles.value = true;
        privateBottles.clear();
      }

      if (!hasMoreBottles.value) return;
      final response = await _userApi.getBottles(
        userId: user.value!.id,
        page: 1,
        pageSize: 20,
        isPublic: false,
      );

      if (response.success) {
        final bottles = response.data ?? [];
        if (bottles.isEmpty) {
          hasMoreBottles.value = false;
        } else {
          privateBottles.assignAll(bottles);
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

  // 刷新私密漂流瓶列表
  Future<void> refreshPrivateBottles() async {
    await fetchPrivateBottles(refresh: true);
  }

  // 加载更多私密漂流瓶
  Future<void> loadMorePrivateBottles() async {
    await fetchPrivateBottles();
  }

  // 加载更多漂流瓶
  Future<void> loadMoreBottles() async {
    await fetchPublicBottles();
  }
}
