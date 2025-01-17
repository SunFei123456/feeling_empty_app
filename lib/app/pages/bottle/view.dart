import 'dart:math';

import 'package:fangkong_xinsheng/app/core/services/app_service.dart';
import 'package:fangkong_xinsheng/app/core/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fangkong_xinsheng/app/pages/square/views/bottle_card_detail.dart';
import 'dart:ui' show lerpDouble;

import 'package:fangkong_xinsheng/app/router/index.dart';
import 'package:fangkong_xinsheng/app/pages/profile/controller/profile_controller.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/widget/hot_topics.dart';
import 'package:fangkong_xinsheng/app/pages/views/controller/topic_controller.dart';

class BottlePage extends StatefulWidget {
  const BottlePage({super.key});

  @override
  State<BottlePage> createState() => _BottlePageState();
}

class _BottlePageState extends State<BottlePage> {
  late final ProfileController _profileController;
  final _appService = Get.find<AppService>();

  @override
  void initState() {
    super.initState();
    _profileController = Get.put(
      ProfileController(),
      tag: 'current_user',
      permanent: true,
    );

    if (!Get.isRegistered<TopicController>()) {
      Get.put(TopicController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: Stack(
            children: [
              // 海洋动态背景
              _buildOceanBackground(),

              // 主要内容
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // 顶部AppBar
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: BottleHeaderDelegate(_profileController),
                  ),

                  // 内容区域
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          // 漂流瓶动画展示区
                          _buildBottleShowcase(),
                          const SizedBox(height: 30),

                          // 快捷操作区
                          _buildQuickActions(_appService.isDarkMode),
                          const SizedBox(height: 30),

                          // 热门话题区
                          _buildHotTopics(),
                          const SizedBox(height: 20),

                          // 推荐的漂流瓶
                          _buildRecentBottles(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildOceanBackground() {
    return Stack(
      children: [
        // 渐变背景
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[200]!.withOpacity(0.3),
                Colors.blue[400]!.withOpacity(0.2),
                Colors.purple[200]!.withOpacity(0.1),
              ],
            ),
          ),
        ),

        // 波浪动画效果
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: WaveAnimation(),
        ),
      ],
    );
  }

  Widget _buildBottleShowcase() {
    return Container(
      height: 180,
      child: Row(
        children: [
          // 左侧大卡片
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue[400]!,
                    Colors.blue[600]!,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // 装饰性图案
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),

                  // 内容
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: InkWell(
                      onTap: () => AppRoutes.to(AppRoutes.OCEANSQUARE),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.explore,
                            color: Colors.white,
                            size: 32,
                          ),
                          const Spacer(),
                          Text(
                            'explore_the_world'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'explore_more_content'.tr,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
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

          // 右侧两个小卡片
          Expanded(
            child: Column(
              children: [
                _buildSmallCard(
                  icon: Icons.create,
                  title: 'write_a_drift_bottle'.tr,
                  color: Colors.purple,
                  onTap: () => AppRoutes.to(AppRoutes.WRITE_BOTTLE),
                ),
                const SizedBox(height: 8),
                _buildSmallCard(
                  icon: Icons.local_fire_department,
                  title: 'trending_bottles'.tr,
                  color: Colors.orange,
                  onTap: () => AppRoutes.to(AppRoutes.HOT_BOTTLE),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                top: -10,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 24,
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(bool isDarkMode) {
    final actions = [
      {
        'icon': Icons.local_fire_department,
        'label': 'trending',
        'color': Colors.orange,
        'page_url': AppRoutes.HOT_BOTTLE
      },
      {
        'icon': Icons.explore,
        'label': 'resonance',
        'color': Colors.lightGreen,
        'page_url': AppRoutes.RESONATED_BOTTLE
      },
      {
        'icon': Icons.collections_bookmark,
        'label': 'favorites',
        'color': Colors.red,
        'page_url': AppRoutes.FAVORITED_BOTTLE
      },
      {
        'icon': Icons.history,
        'label': 'history',
        'color': Colors.purple,
        'page_url': AppRoutes.VIEW_HISTORY
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions.map((action) {
        return GestureDetector(
          onTap: () {
            AppRoutes.to(action['page_url'] as String);
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (action['color'] as Color).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  action['icon'] as IconData,
                  color: action['color'] as Color,
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                (action['label'] as String).tr,
                style: TextStyle(
                  color: isDarkMode ? Colors.black : Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHotTopics() {
    return HotTopicsWidget();
  }

  Widget _buildRecentBottles() {
    // 模拟数据
    final List<Map<String, dynamic>> mockBottles = List.generate(
      10,
      (index) => {
        'id': index,
        'title': '这是一个漂流瓶标题 ${index + 1}',
        'content': '这是漂流瓶的预览内容，可能包含一些文字描述...',
        'createdAt': '2024-03-${10 + index}',
        'views': Random().nextInt(1000),
        'imageUrl': index % 2 == 0
            ? 'https://picsum.photos/500/${300 + index * 50}'
            : '',
        'user': null,
        'audioUrl': '',
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'recommended_drift_bottles'.tr,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800]),
            ),
            TextButton(
              onPressed: () => AppRoutes.to(AppRoutes.OCEANSQUARE),
              child: Text(
                'view_more'.tr,
                style: TextStyle(
                  color: Colors.blue[400],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        MasonryGridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          itemCount: mockBottles.length,
          itemBuilder: (context, index) {
            final bottle = mockBottles[index];

            return GestureDetector(
              onTap: () {
                Get.to(
                  () => BottleCardDetail(
                    id: bottle['id'],
                    imageUrl: bottle['imageUrl'].isNotEmpty
                        ? bottle['imageUrl']
                        : 'https://picsum.photos/500/800',
                    title: bottle['title'],
                    content: bottle['content'],
                    createdAt: bottle['createdAt'],
                    audioUrl: bottle['audioUrl'],
                    user: bottle['user'],
                  ),
                  transition: Transition.fadeIn,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: _appService.isDarkMode
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
                      if (bottle['imageUrl'].isNotEmpty)
                        AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            bottle['imageUrl'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bottle['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              bottle['content'],
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      '${bottle['views']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  bottle['createdAt'],
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
      ],
    );
  }
}

// 波浪动画组件
class WaveAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      // 实现波浪动画效果
    );
  }
}

// 漂流瓶3D动画组件
class BottleAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        // 实现漂流瓶3D动画效果
        );
  }
}

class BottleHeaderDelegate extends SliverPersistentHeaderDelegate {
  final ProfileController profileController;

  BottleHeaderDelegate(this.profileController);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // 计算滚动进度 (0.0 到 1.0)
    final progress = shrinkOffset / maxExtent;
    final fontSize = lerpDouble(28, 20, progress) ?? 28;
    final paddingLeft = lerpDouble(16, 16, progress) ?? 10;

    return Container(
      decoration: BoxDecoration(
        color: shrinkOffset > 0
            ? Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9)
            : Colors.transparent,
        boxShadow: [
          if (shrinkOffset > 0)
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.only(left: paddingLeft, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: paddingLeft, bottom: 0),
                child: Text(
                  'bottle_title'.tr,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 5),
                child: Row(
                  children: [
                    const Text(
                      "Hi~",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        AppRoutes.to('/profile');
                      },
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue[100],
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Obx(() {
                          final user = profileController.user.value;
                          return ClipOval(
                            child: user?.avatar != null &&
                                    user!.avatar.isNotEmpty
                                ? Image.network(
                                    user.avatar,
                                    width: 46,
                                    height: 46,
                                    fit: BoxFit.cover,
                                    headers: const {
                                      'Cache-Control': 'no-cache',
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                          strokeWidth: 2,
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                      Icons.person,
                                      size: 20,
                                      color: Colors.blue[400],
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 20,
                                    color: Colors.blue[400],
                                  ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 100.0;

  @override
  double get minExtent => 80.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
