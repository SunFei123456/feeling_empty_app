import 'package:fangkong_xinsheng/app/core/services/token_service.dart';
import 'package:fangkong_xinsheng/app/pages/profile/views/profile_page.dart';
import 'package:fangkong_xinsheng/app/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/profile/model/follower.dart';
import 'package:fangkong_xinsheng/app/pages/profile/controller/profile_controller.dart';

class FollowListPage extends StatefulWidget {
  final String title;
  final bool isFollowers; // true: 粉丝列表, false: 关注列表
  final int? userId;

  const FollowListPage({
    super.key,
    required this.title,
    required this.isFollowers,
    this.userId,
  });

  @override
  State<FollowListPage> createState() => _FollowListPageState();
}

class _FollowListPageState extends State<FollowListPage> {
  late ProfileController profileController;
  late bool isCurrentUser; // 用于判断是否是当前用户 --> 当前页面主要用于控制 关注状态的显示, 非当前用户即查看他人的粉丝/关注列表则不应展示其状态操作

  @override
  void initState() {
    isCurrentUser = TokenService().getUserId() == widget.userId;
    super.initState();
    if (widget.userId == null) {
      Get.back();
      return;
    }
    
    profileController = Get.put(
      ProfileController(userId: widget.userId),
    );
    widget.isFollowers
        ? profileController.getFans(widget.userId!)
        : profileController.getFollowers(widget.userId!);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      body: Obx(() {
        final userList = widget.isFollowers
            ? profileController.following
            : profileController.followers;

        if (userList.isEmpty) {
          return _buildEmptyState(isDark);
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: userList.length,
          itemBuilder: (context, index) => _buildUserItem(
            context,
            userList[index],
            isDark,
          ),
        );
      }),
    );
  }

  // 空状态显示
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.isFollowers ? Icons.people_outline : Icons.person_outline,
              size: 64, color: isDark ? Colors.white38 : Colors.black26),
          const SizedBox(height: 16),
          Text(
            widget.isFollowers ? '暂无粉丝' : '暂无关注',
            style: TextStyle(
                fontSize: 16, color: isDark ? Colors.white38 : Colors.black38),
          ),
        ],
      ),
    );
  }

  Widget _buildUserItem(BuildContext context, Follower follower, bool isDark) {
    final user = follower.user;
    if (user == null) return const SizedBox();

    return InkWell(
      onTap: () => Get.to(() => ProfilePage(userId: user.id)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // 头像
            CircleAvatar(radius: 24, backgroundImage: NetworkImage(user.avatar)),
            const SizedBox(width: 12),
            // 用户信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.nickname,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        user.sex == 1 ? Icons.male : Icons.female,
                        size: 16,
                        color: user.sex == 1 ? Colors.blue : Colors.pink,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '关注时间：${formatTimeOnlyDate(follower.followAt)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            // 只有当是当前用户的列表时才显示关注按钮
            if (isCurrentUser) _buildFollowButton(follower.followStatus, user.id, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowButton(String status, int userId, bool isDark) {
    // 通用按钮样式
    const buttonHeight = 32.0; // 减小高度
    const fontSize = 12.0; // 减小字体大小
    const horizontalPadding = 12.0; // 减小水平内边距

    // 如果是粉丝列表，显示不同的按钮状态
    if (widget.isFollowers) {
      switch (status) {
        case 'mutual_following':
          return SizedBox(
            height: buttonHeight,
            child: OutlinedButton(
              onPressed: () async {
                // 取关
                await profileController.unfollowUser(userId);
                // 刷新粉丝列表数据
                await profileController.refreshFans(widget.userId!);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white70 : Colors.black87,
                side: BorderSide(
                  color: isDark ? Colors.white24 : Colors.black26,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(buttonHeight / 2),
                ),
                padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
              ),
              child: const Text('互相关注', style: TextStyle(fontSize: fontSize)),
            ),
          );
        case 'followed':
          return SizedBox(
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: () async {
                // 回关
                await profileController.followUser(userId);
                // 刷新粉丝列表数据
                await profileController.refreshFans(widget.userId!);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(buttonHeight / 2),
                ),
                padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
              ),
              child: const Text('回关', style: TextStyle(fontSize: fontSize)),
            ),
          );
        default:
          return const SizedBox();
      }
    }

    // 关注列表
    switch (status) {
      case 'following':
        return SizedBox(
          height: buttonHeight,
          child: OutlinedButton(
            onPressed: () async {
              await profileController.unfollowUser(userId);
              await profileController.refreshFollowers(widget.userId!);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? Colors.white70 : Colors.black87,
              side: BorderSide(
                color: isDark ? Colors.white24 : Colors.black26,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(buttonHeight / 2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            ),
            child: const Text(
              '已关注',
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        );
      case 'mutual_following':
        return SizedBox(
          height: buttonHeight,
          child: OutlinedButton(
            onPressed: () async {
              await profileController.unfollowUser(userId);
              await profileController.refreshFollowers(widget.userId!);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? Colors.white70 : Colors.black87,
              side: BorderSide(
                color: isDark ? Colors.white24 : Colors.black26,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(buttonHeight / 2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            ),
            child: const Text(
              '互相关注',
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        );
      case 'not_following':
        return SizedBox(
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: () async {
              await profileController.followUser(userId);
              await profileController.refreshFollowers(widget.userId!);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(buttonHeight / 2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            ),
            child: const Text('关注', style: TextStyle(fontSize: fontSize)),
          ),
        );
      default:
        return const SizedBox();
    }
  }
}
