import 'dart:ui';
import 'dart:io';
import 'package:fangkong_xinsheng/app/core/services/token_service.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/api/index.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:fangkong_xinsheng/app/pages/home/model/user.dart';
import 'package:fangkong_xinsheng/app/pages/login/model/login.dart';
import 'package:fangkong_xinsheng/app/pages/square/views/bottle_card_detail.dart';
import 'package:fangkong_xinsheng/app/utils/index.dart';
import 'package:fangkong_xinsheng/app/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fangkong_xinsheng/app/pages/setting/controller.dart';
import 'package:fangkong_xinsheng/app/widgets/custom_drawer.dart';
import 'package:fangkong_xinsheng/app/pages/profile/controller/profile_controller.dart';
import 'package:fangkong_xinsheng/app/router/index.dart';
import 'package:fangkong_xinsheng/app/pages/profile/views/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final int? userId;

  const ProfilePage({
    Key? key,
    this.userId,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final SettingController _settingController;
  late final ProfileController _profileController;
  late final bool _isCurrentUser;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _settingController = Get.find<SettingController>();

    // 在这里处理用户身份校验
    _isCurrentUser = widget.userId == null || isCurrentUser(widget.userId!);

    // 根据是否是当前用户决定使用哪个 tag
    _profileController = Get.put(
      ProfileController(userId: _isCurrentUser ? null : widget.userId),
      tag: _isCurrentUser ? 'current_user' : widget.userId.toString(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          // 背景渐变模糊效果
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.withOpacity(0.5),
                  Colors.pink.withOpacity(0.1),
                  Colors.white.withOpacity(0.2),
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ),

          // 主要内容
          SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // 顶部栏
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => Get.back(),
                              ),
                              Obx(() => Text(
                                    '@${_profileController.user.value?.nickname ?? ""}',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF1A1A1A),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                              const Spacer(),
                              !_isCurrentUser
                                  ? const SizedBox()
                                  : IconButton(
                                      icon: const Icon(Icons.more_horiz),
                                      onPressed: () {
                                        showGeneralDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          barrierLabel: '',
                                          barrierColor: Colors.black54,
                                          transitionDuration:
                                              const Duration(milliseconds: 300),
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return SlideTransition(
                                              position: Tween<Offset>(
                                                begin: const Offset(1, 0),
                                                end: Offset.zero,
                                              ).animate(CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.easeInOut,
                                              )),
                                              child: CustomDrawer(
                                                settingController:
                                                    _settingController,
                                                profileController:
                                                    _profileController,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),

                        // 个人信息卡片
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.black.withAlpha(200)
                                : Colors.white.withAlpha(200),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Obx(() {
                            final user = _profileController.user.value;
                            final isLoading =
                                _profileController.isLoading.value;

                            if (isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (user == null) {
                              return const Center(
                                child: Text('用户不存在'),
                              );
                            }

                            return Stack(
                              children: [
                                Column(
                                  children: [
                                    // 头像
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: user.avatar.isNotEmpty
                                              ? NetworkImage(user.avatar)
                                              : const AssetImage(
                                                      'assets/images/avatar.jpg')
                                                  as ImageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // 用户名和认证标记
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          user.nickname,
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white
                                                : const Color(0xFF1A1A1A),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.verified,
                                          size: 20,
                                          color: Colors.blue[400],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),

                                    // 描述
                                    Text(
                                      'Twice K-Pop Idol Group Member',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    // 统计数据
                                    _buildUserStats(),
                                    const SizedBox(height: 20),

                                    // Follow 按钮
                                    !_isCurrentUser
                                        ? SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                                onPressed: () {
                                              
                                                  if (_profileController
                                                          .followStatus.value ==
                                                      'not_following') {
                                                    _profileController
                                                        .followUser(
                                                            widget.userId!);
                                                  } else {
                                                    _profileController
                                                        .unfollowUser(
                                                            widget.userId!);
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  // 互相关注 浅灰半透明色
                                                  // 已关注 橙色
                                                  // 未关注 蓝色
                                                  backgroundColor:
                                                      getFollowStatusColor(
                                                          _profileController
                                                              .followStatus
                                                              .value),
                                                  foregroundColor: Colors.white,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                                child: Text(getFollowStatusText(
                                                    _profileController
                                                        .followStatus.value))),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                // 编辑按钮
                                _isCurrentUser
                                    ? Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () async {
                                            final result = await AppRoutes.to(
                                                AppRoutes.EDIT_PROFILE,
                                                arguments: _isCurrentUser
                                                    ? 'current_user'
                                                    : widget.userId.toString());

                                            if (result == true) {
                                              await _profileController
                                                  .refreshUserInfo();
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20),
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.edit,
                                              color: isDark
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black.withOpacity(0.7),
                        padding: const EdgeInsets.all(3),
                        tabs: [
                          Tab(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Center(child: Text('公开')),
                            ),
                          ),
                          Tab(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Center(child: Text('私密')),
                            ),
                          ),
                        ],
                        dividerColor: Colors.transparent,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  // 公开照片瀑布流
                  RefreshIndicator(
                    onRefresh: _profileController.refreshBottles,
                    child: MasonryGridView.count(
                      padding: const EdgeInsets.all(16),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      itemCount: _profileController.publicBottles.length,
                      itemBuilder: (context, index) {
                        if (index >= _profileController.publicBottles.length) {
                          return const SizedBox();
                        }

                        final bottle = _profileController.publicBottles[index];

                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => BottleCardDetail(
                                id: bottle.id,
                                imageUrl: bottle.imageUrl.isNotEmpty
                                    ? bottle.imageUrl
                                    : 'https://picsum.photos/500/800',
                                title: bottle.title,
                                content: bottle.content,
                                createdAt: bottle.createdAt,
                                audioUrl: bottle.audioUrl,
                                user: bottle.user,
                              ),
                              transition: Transition.fadeIn,
                            );
                          },
                          onLongPress: () => _showBottomDrawer(context, bottle),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.black.withAlpha(200)
                                    : Colors.white.withAlpha(200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (bottle.imageUrl.isNotEmpty)
                                    AspectRatio(
                                      aspectRatio: 1,
                                      child: Image.network(
                                        bottle.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bottle.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          bottle.content,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                            height: 1.2,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.remove_red_eye,
                                                  size: 12,
                                                  color: Colors.grey[400],
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${bottle.views}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              bottle.createdAt.substring(0, 10),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // 私密漂流瓶
                  RefreshIndicator(
                    onRefresh: _profileController.refreshPrivateBottles,
                    child: Obx(() {
                      if (_profileController.isLoadingPrivate.value &&
                          _profileController.privateBottles.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (_profileController.privateBottles.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock_outline,
                                  size: 64, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text(
                                '暂无私密漂流瓶',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return MasonryGridView.count(
                        padding: const EdgeInsets.all(16),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        itemCount: _profileController.privateBottles.length,
                        itemBuilder: (context, index) {
                          final bottle =
                              _profileController.privateBottles[index];

                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                () => BottleCardDetail(
                                  id: bottle.id,
                                  imageUrl: bottle.imageUrl.isNotEmpty
                                      ? bottle.imageUrl
                                      : 'https://picsum.photos/500/800',
                                  title: bottle.title,
                                  content: bottle.content,
                                  createdAt: bottle.createdAt,
                                  audioUrl: bottle.audioUrl,
                                  user: bottle.user,
                                ),
                                transition: Transition.fadeIn,
                              );
                            },
                            onLongPress: () =>
                                _showBottomDrawer(context, bottle),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (bottle.imageUrl.isNotEmpty)
                                          AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.network(
                                              bottle.imageUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                bottle.title,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                bottle.content,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                  height: 1.2,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.remove_red_eye,
                                                        size: 12,
                                                        color: Colors.grey[400],
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        '${bottle.views}',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    bottle.createdAt
                                                        .substring(0, 10),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    // 私密标记
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.lock_outline,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '私密',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          '${0}',
          '漂流瓶',
        ),
        _buildStatDivider(),
        // 关注数量，可点击
        InkWell(
          onTap: () => AppRoutes.to(
            AppRoutes.FOLLOWING,
            arguments: {
              'userId': widget.userId ?? TokenService().getUserId(),
                
            },
          ),
          child: _buildStatItem(
            '${0}',
            '关注',
          ),
        ),
        _buildStatDivider(),
        // 粉丝数量，可点击
        InkWell(
          onTap: () => AppRoutes.to(
            AppRoutes.FOLLOWERS,
            arguments: {
              'userId': widget.userId ?? TokenService().getUserId(),
              
            },
          ),
          child: _buildStatItem(
            '${0}',
            '粉丝',
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(height: 30, width: 1, color: Colors.grey[300]);
  }

  void _showBottomDrawer(BuildContext context, BottleModel bottle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 顶部拖动条
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 操作按钮
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('删除', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context); // 先关闭底部抽屉
                ConfirmDialog.show(
                  title: "删除确认",
                  content: "确认要删除此漂流瓶吗？",
                  confirmText: "删除",
                  cancelText: "取消",
                  onConfirm: () async {
                    try {
                      final response =
                          await BottleApiService().deleteBottle(bottle.id);
                      if (response.success) {
                        Get.snackbar('成功', '删除成功');
                        _profileController.refreshBottles();
                      } else {
                        Get.snackbar('错误', response.message ?? '删除失败');
                      }
                    } catch (e) {
                      Get.snackbar('错误', '删除失败: $e');
                    }
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.visibility_off, color: Colors.orange),
              title:
                  const Text('修改可见性', style: TextStyle(color: Colors.orange)),
              onTap: () {
                Navigator.pop(context);
                // 修改可见性逻辑
                BottleApiService().updateBottleVisibility(bottle.id, false);
                // 修改后刷新列表
                _profileController.refreshBottles();
                _profileController.refreshPrivateBottles();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.blue),
              title: const Text('分享', style: TextStyle(color: Colors.blue)),
              onTap: () {
                Navigator.pop(context);
                // todo 分享逻辑
              },
            ),
            // 底部安全区域
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

// 添加这个委托类来处理 Tab 栏的吸附效果
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => 44;
  @override
  double get maxExtent => 44;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
