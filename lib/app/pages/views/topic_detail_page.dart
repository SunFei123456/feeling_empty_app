import 'package:fangkong_xinsheng/app/pages/bottle/view/write_bottle_page.dart';
import 'package:fangkong_xinsheng/app/pages/square/views/bottle_card_detail.dart';
import 'package:fangkong_xinsheng/app/pages/views/controller/topic_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';


class TopicDetailPage extends StatefulWidget {
  final String topicName;
  final int bottleCount;
  final int topicId;

  const TopicDetailPage({
    super.key,
    required this.topicName,
    required this.bottleCount,
    required this.topicId,
  });

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final PageController _pageController;
  final TopicController _topicController = Get.find<TopicController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    _pageController = PageController();
    _topicController.initTopicDetail(widget.topicId);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _pageController.animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // 顶部 SliverAppBar
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue[600]!,
                        Colors.blue[400]!.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // 话题标题区域
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                                child: Icon(
                                  Icons.tag,
                                  size: 40,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(
                                      () => _topicController.isDetailLoading.value
                                          ? const Center(child: CircularProgressIndicator())
                                          : Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Obx(() => Text(
                                                      _topicController.topicDetail.value.title,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    )),
                                                const SizedBox(height: 8),
                                                Obx(() => Text(
                                                      _topicController.topicDetail.value.desc,
                                                      style: TextStyle(
                                                        color: Colors.white.withOpacity(0.9),
                                                        fontSize: 13,
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    )),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // 底部数据统计
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              Obx(() => _buildStatItem(
                                    value: '${_topicController.topicDetail.value.contentCount}',
                                    label: 'content'.tr,
                                  )),
                              const SizedBox(width: 30),
                              Obx(() => _buildStatItem(
                                    value: '${_topicController.topicDetail.value.participantCount}',
                                    label: 'participates'.tr,
                                  )),
                              const SizedBox(width: 30),
                              Obx(() => _buildStatItem(
                                    value: '${_topicController.topicDetail.value.views}',
                                    label: 'views'.tr,
                                  )),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(
                                    () => WriteBottlePage(
                                      defaultTopic: _topicController.topicDetail.value.title,
                                      defaultTopicId: widget.topicId,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.blue[600],
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  'join_topic'.tr,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                expandedTitleScale: 1.0,
              ),
            ),

            // Tab栏
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  tabAlignment: TabAlignment.start,
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: isDark ? Colors.white : Colors.black,
                  labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  unselectedLabelColor: isDark ? Colors.grey[600] : Colors.grey,
                  indicatorColor: isDark ? Colors.white : Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  indicatorPadding: const EdgeInsets.only(bottom: 4, top: 2),
                  indicatorWeight: 1,
                  tabs: [
                    Tab(text: 'hottest'.tr),
                    Tab(text: 'latest'.tr),
                  ],
                ),
              ),
            ),
          ];
        },
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            _tabController.animateTo(index);
            // 根据选中的 tab 刷新数据
            if (index == 0) {
              _topicController.loadTopicBottles(widget.topicId, isHot: true);
            } else {
              _topicController.loadTopicBottles(widget.topicId, isHot: false);
            }
          },
          children: [
            _buildBottleList(true),
            _buildBottleList(false),
          ],
        ),
      ),
    );
  }

  Widget _buildBottleList(bool isHotTab) {
    return Obx(() => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: _topicController.bottles.length,
          itemBuilder: (context, index) {
            final bottle = _topicController.bottles[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildBottleCard(context, bottle),
            );
          },
        ));
  }

  Widget _buildBottleCard(BuildContext context, BottleModel bottle) {
    // 判断瓶子类型
    bool isImageBottle = bottle.imageUrl.isNotEmpty;
    bool isAudioBottle = bottle.audioUrl.isNotEmpty;
    bool isTextBottle = !isImageBottle && !isAudioBottle;

    // 定义渐变背景颜色
    List<Color> getGradientColors() {
      if (isAudioBottle) {
        return [
          const Color(0xFFFF8C61), // 珊瑚色
          const Color(0xFFFF6B6B), // 粉红色
          const Color(0xFFFF5F6D), // 玫瑰色
        ];
      } else {
        return [
          const Color(0xFF4FACFE), // 天蓝色
          const Color(0xFF00F2FE), // 青色
          const Color(0xFF00DBDE), // 蓝绿色
        ];
      }
    }

    return GestureDetector(
      onTap: () {
        Get.to(
          () => BottleCardDetail(
            id: bottle.id,
            title: bottle.title,
            content: bottle.content,
            imageUrl: bottle.imageUrl,
            audioUrl: bottle.audioUrl,
            createdAt: bottle.createdAt,
            user: bottle.user,
            views: bottle.views,
            resonates: bottle.resonates,
            isResonated: bottle.isResonated,
            isFavorited: bottle.isFavorited,
            favorites: bottle.favorites,
            shares: bottle.shares,
            mood: bottle.mood,
          ),
        );
      },
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 背景
                    if (isImageBottle)
                      Image.network(
                        bottle.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                      )
                    else
                      // 纯色渐变背景
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: getGradientColors(),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            isAudioBottle ? Icons.audiotrack : Icons.format_quote_rounded,
                            size: 48,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),

                    // 渐变遮罩
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),

                    // 类型标识
                    Positioned(
                      left: 16,
                      top: 16,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isImageBottle
                              ? Icons.image
                              : isAudioBottle
                                  ? Icons.audiotrack
                                  : Icons.text_fields,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bottle.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_outlined,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            bottle.createdAt,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.remove_red_eye_outlined,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${bottle.views}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.favorite_border,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${bottle.resonates}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
