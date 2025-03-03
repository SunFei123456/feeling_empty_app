import 'dart:math';

import 'package:fangkong_xinsheng/app/core/services/app_service.dart';
import 'package:fangkong_xinsheng/app/widgets/cache_user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
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
    _profileController = Get.put(ProfileController(), tag: 'current_user', permanent: true);

    if (!Get.isRegistered<TopicController>()) {
      Get.put(TopicController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: _appService.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
          body: Stack(
            children: [
              // 海洋动态背景
              // _buildOceanBackground(),

              // 主要内容
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // 顶部AppBar
                  SliverPersistentHeader(pinned: true, delegate: BottleHeaderDelegate(_profileController)),

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
              BoxShadow(color: color.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4)),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                top: -10,
                child: Container(width: 50, height: 50, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1))),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(icon, color: Colors.white, size: 24),
                    const Spacer(),
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
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
      {'icon': Icons.local_fire_department, 'label': 'trending', 'color': Colors.orange, 'page_url': AppRoutes.HOT_BOTTLE},
      {'icon': Icons.explore, 'label': 'resonance', 'color': Colors.lightGreen, 'page_url': AppRoutes.RESONATED_BOTTLE},
      {'icon': Icons.collections_bookmark, 'label': 'favorites', 'color': Colors.red, 'page_url': AppRoutes.FAVORITED_BOTTLE},
      {'icon': Icons.history, 'label': 'history', 'color': Colors.purple, 'page_url': AppRoutes.VIEW_HISTORY},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions.map((action) {
        return GestureDetector(
          onTap: () => AppRoutes.to(action['page_url'] as String),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: (action['color'] as Color).withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(action['icon'] as IconData, color: action['color'] as Color, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                (action['label'] as String).tr,
                style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87, fontSize: 12),
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
        'imageUrl': index % 2 == 0 ? 'https://picsum.photos/500/${300 + index * 50}' : '',
        'user': null,
        'audioUrl': '',
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('recommended_drift_bottles'.tr, style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color:  _appService.isDarkMode ? Colors.white70 : Colors.black87)),
            TextButton(
              onPressed: () => AppRoutes.to(AppRoutes.OCEANSQUARE),
              child: Row(
                children: [
                  Text('view_more'.tr, style:  TextStyle(color: _appService.isDarkMode ? Colors.white70 : Colors.black87, fontSize: 14)),
                  // icon
                   Icon(Icons.arrow_forward_ios, size: 12, color:  _appService.isDarkMode ? Colors.white70 : Colors.black87),
                ],
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
                      id: bottle['id'], imageUrl: bottle['imageUrl'].isNotEmpty ? bottle['imageUrl'] : 'https://picsum.photos/500/800', title: bottle['title'], content: bottle['content'], createdAt: bottle['createdAt'], audioUrl: bottle['audioUrl'], user: bottle['user'], mood: bottle['mood']),
                  transition: Transition.fadeIn,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: _appService.isDarkMode ? Colors.black.withAlpha(200) : Colors.white.withAlpha(200),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (bottle['imageUrl'].isNotEmpty) AspectRatio(aspectRatio: 1, child: Image.network(bottle['imageUrl'], fit: BoxFit.cover)),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(bottle['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 8),
                            Text(bottle['content'], style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.remove_red_eye, size: 12, color: Colors.grey[400]),
                                    const SizedBox(width: 4),
                                    Text('${bottle['views']}', style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                                  ],
                                ),
                                Text(bottle['createdAt'], style: TextStyle(fontSize: 12, color: Colors.grey[400])),
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

class BottleHeaderDelegate extends SliverPersistentHeaderDelegate {
  final ProfileController profileController;

  BottleHeaderDelegate(this.profileController);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isDarkMode = Get.find<AppService>().isDarkMode;
    // 计算滚动进度 (0.0 到 1.0)
    final progress = shrinkOffset / maxExtent;
    final fontSize = lerpDouble(28, 20, progress) ?? 28;
    final paddingLeft = lerpDouble(16, 16, progress) ?? 10;

    return Container(
      decoration: BoxDecoration(
        color: shrinkOffset > 0 ? Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9) : Colors.transparent,
        boxShadow: [
          if (shrinkOffset > 0) BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
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
                    color: isDarkMode ? Colors.white.withOpacity(progress.clamp(0.7, 1.0)) : Colors.black.withOpacity(progress.clamp(0.7, 1.0)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 5),
                child: Row(
                  children: [
                    const Text("Hi~", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () => AppRoutes.to('/profile'),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue[100],
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Obx(() {
                          final user = profileController.user.value;
                          // size 随 progress 而缩小
                          return CacheUserAvatar(avatarUrl: user?.avatar ?? '', size: lerpDouble(40, 30, progress) ?? 40);
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
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
