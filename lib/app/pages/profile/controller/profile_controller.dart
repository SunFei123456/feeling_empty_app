import 'dart:io';
import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:fangkong_xinsheng/app/pages/profile/model/follower.dart';
import 'package:fangkong_xinsheng/app/pages/profile/model/user_stat.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/profile/api/user.dart';
import 'package:fangkong_xinsheng/app/pages/profile/model/user.dart';
import 'package:fangkong_xinsheng/app/core/services/upload_service.dart';
import 'package:fangkong_xinsheng/app/core/services/token_service.dart';

class ProfileController extends GetxController {
  final int? userId;

  ProfileController({this.userId});

  final _userApi = UserApiService();
  final _uploadService = UploadService();
  final user = Rxn<UserModel>(); // 用户信息
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

  final userStat = UserStat().obs; // 用户数据

  @override
  void onInit() {
    super.onInit();
    if (userId != null) {
      loadUserProfile(userId!);
    } else {
      // 如果没有传入 userId，则加载当前用户信息
      final currentUserId = TokenService().getUserId();
      if (currentUserId != null) {
        loadUserProfile(currentUserId);
      }
    }
  }

  // 该接口 是聚合结合, 在调用完获取用户信息接口之后 同步获取用户的社交数据, 作品(私密和公开), 以及关注状态
  Future<void> loadUserProfile(int userId) async {
    try {
      isLoading.value = true;
      final response = await _userApi.getUserInfoByUid(userId);
      if (response.success) {
        user.value = response.data;
        await Future.wait([
          getUserStat(userId),
          fetchPublicBottles(userId, refresh: true),
          fetchPrivateBottles(userId, refresh: true),
          getFollowStatus(userId),
        ]);
      } else {
        Get.snackbar('错误', response.message ?? '获取用户信息失败');
      }
    } catch (e) {
      Get.snackbar('错误', '获取用户信息失败');
    } finally {
      isLoading.value = false;
    }
  }

  // 根据uid 获取用户信息
  Future<void> getUserInfoByUid(int uid) async {
    try {
      isLoading.value = true;
      final response = await _userApi.getUserInfoByUid(uid);

      if (response.success) {
        user.value = response.data;
        // 获取用户信息成功后再获取漂流瓶
        await fetchPublicBottles(uid, refresh: true);
      } else {
        Get.snackbar('错误', response.message ?? '获取用户信息失败');
      }
    } catch (e) {
      Get.snackbar('错误', '获取用户信息失败');
    } finally {
      isLoading.value = false;
    }
  }

  // 获取两人的关注状态
  Future<void> getFollowStatus(int userId) async {
    final response = await _userApi.getFollowStatus(userId);
    if (response.success) {
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

  // 获取用户的社交数据
  Future<void> getUserStat(int userId) async {
    try {
      final response = await _userApi.getUserStat(userId);
      if (response.success) {
        userStat.value = response.data ?? UserStat();
      } else {
        Get.snackbar('错误', response.message ?? '获取用户统计数据失败');
      }
    } catch (e) {
      Get.snackbar('错误', '获取用户统计数据失败');
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
        await fetchPublicBottles(user.value!.id, refresh: true);
      } else {
        Get.snackbar('错误', response.message ?? '获取用户信息失败');
      }
    } catch (e) {
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
      Get.snackbar('错误', '更新用户信息失败');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // 刷新用户信息
  Future<void> refreshUserInfo(int userId) async {
    try {
      isLoading.value = true;
      // 只调用 loadUserProfile，因为它已经包含了所有需要的数据加载
      await loadUserProfile(userId);
    } finally {
      isLoading.value = false;
    }
  }

  // 获取用户公开的漂流瓶
  Future<void> fetchPublicBottles(int userId, {bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 1;
        hasMoreBottles.value = true;
        publicBottles.clear();
      }

      if (!hasMoreBottles.value) return;

      final response = await _userApi.getBottles(
        userId: userId,
        page: currentPage.value,
        pageSize: pageSize,
        isPublic: true,
      );

      if (response.success) {
        final bottles = response.data ?? [];
        if (bottles.isEmpty) {
          hasMoreBottles.value = false;
        } else {
          if (refresh) {
            publicBottles.assignAll(bottles);
          } else {
            publicBottles.addAll(bottles);
          }
          currentPage.value++;
        }
      }
    } catch (e) {
      print('Fetch public bottles error: $e');
    }
  }

  // 获取私密漂流瓶
  Future<void> fetchPrivateBottles(int userId, {bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 1;
        hasMoreBottles.value = true;
        privateBottles.clear();
      }

      if (!hasMoreBottles.value) return;

      final response = await _userApi.getBottles(
        userId: userId,
        page: currentPage.value,
        pageSize: pageSize,
        isPublic: false,
      );

      if (response.success) {
        final bottles = response.data ?? [];
        if (bottles.isEmpty) {
          hasMoreBottles.value = false;
        } else {
          // 使用 assignAll 而不是 addAll 来确保触发UI更新
          if (refresh) {
            privateBottles.assignAll(bottles);
          } else {
            privateBottles.addAll(bottles);
          }
          currentPage.value++;
        }
        // 添加日志
        print('Private bottles loaded: ${privateBottles.length}');
      } else {
        print('Fetch private bottles failed: ${response.message}');
      }
    } catch (e) {
      print('Fetch private bottles error: $e');
    }
  }

  // 刷新漂流瓶列表
  Future<void> refreshBottles(int userId) async {
    await fetchPublicBottles(userId, refresh: true);
  }

  // 刷新私密漂流瓶列表
  Future<void> refreshPrivateBottles(int userId) async {
    await fetchPrivateBottles(userId, refresh: true);
  }

  // 加载更多私密漂流瓶
  Future<void> loadMorePrivateBottles() async {
    final targetUserId = userId ?? user.value?.id;
    if (targetUserId != null) {
      await fetchPrivateBottles(targetUserId);
    }
  }

  // 加载更多漂流瓶
  Future<void> loadMoreBottles() async {
    final targetUserId = userId ?? user.value?.id;
    if (targetUserId != null) {
      await fetchPublicBottles(targetUserId);
    }
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
