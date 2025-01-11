import 'dart:io';
import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:fangkong_xinsheng/app/pages/profile/model/follower.dart';
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
  final followStatus = ''.obs; // 关注状态
  final followers = <Follower>[].obs; // 关注的人
  final following = <Follower>[].obs; // 粉丝

  @override
  void onInit() {
    super.onInit();
    if (userId != null) {
      loadUserProfile(userId!); // 加载不是当前用户的资料
      getFollowStatus(userId!); // 获取两人的关注状态
    } else {
      loadCurrentUserProfile(); // 加载当前用户的资料
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

  // 获取两人的关注状态
  Future<void> getFollowStatus(int userId) async {
    final response = await _userApi.getFollowStatus(userId);
    if (response.success) {
      print('response.data 关注状态----------> : ${response.data}');
      followStatus.value = response.data ?? '';
    }
  }

  // 关注用户
  Future<void> followUser(int userId) async {
    final response = await _userApi.followUser(userId);
    if (response.success) {
      followStatus.value = 'following';
    }
  }

  // 取消关注用户
  Future<void> unfollowUser(int userId) async {
    try {
      final response = await _userApi.unfollowUser(userId);
      if (response.success) {
        followStatus.value = 'not_following';
      } else {
        Get.snackbar('提示', response.message ?? '取消关注失败');
      }
    } catch (e) {
      print('Unfollow error: $e');
      Get.snackbar('提示', '取消关注失败，请稍后重试');
    }
  }

  // 获取用户关注的人
  Future<void> getFollowers(int userId) async {
    final response = await _userApi.getFollowers(userId);
    if (response.success) {
      followers.value = response.data ?? [];
    }
  }

  // 获取用户粉丝
  Future<void> getFans(int userId) async {
    final response = await _userApi.getFans(userId);
    if (response.success) {
      following.value = response.data ?? [];
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

  // 刷新用户关注列表
  Future<void> refreshFollowers(int userId) async {
    await getFollowers(userId);
  }

  // 刷新用户粉丝列表
  Future<void> refreshFans(int userId) async {
    await getFans(userId);
  }
}
