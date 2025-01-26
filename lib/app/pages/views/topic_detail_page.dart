import 'package:fangkong_xinsheng/app/pages/bottle/view/write_bottle_page.dart';
import 'package:fangkong_xinsheng/app/pages/square/controller/square_controller.dart';
import 'package:fangkong_xinsheng/app/pages/square/views/bottle_card_detail.dart';
import 'package:fangkong_xinsheng/app/pages/views/controller/topic_controller.dart';
import 'package:fangkong_xinsheng/app/widgets/cache_user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';

class TopicDetailPage extends StatefulWidget {
  final int topicId;

  const TopicDetailPage({
    super.key,
    required this.topicId,
  });

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final PageController _pageController;
  final TopicController _topicController = Get.find<TopicController>();
  final SquareController squareController = Get.find<SquareController>();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    // 清理数据
    _topicController.clearTopicDetail();
    // 释放资源
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
                background: Obx(() => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        // 如果背景图为空，使用默认图片
                        _topicController.topicDetail.value.bgImage?.isNotEmpty == true 
                            ? _topicController.topicDetail.value.bgImage!
                            : 'https://picsum.photos/800/600',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // 添加一个遮罩层使内容更容易阅读
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.5),
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
                )),
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
    return Obx(() {
      if (_topicController.isLoading.value && _topicController.bottles.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return RefreshIndicator(
        onRefresh: () => _topicController.loadTopicBottles(widget.topicId, isHot: isHotTab),
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.6),
          itemCount: _topicController.bottles.length,
          itemBuilder: (context, index) {
            final bottle = _topicController.bottles[index];
            return _buildBottleCard(bottle);
          },
        ),
      );
    });
  }

  Widget _buildBottleCard(BottleModel bottle) {
    // 判断瓶子类型
    bool isImageBottle = bottle.imageUrl.isNotEmpty;
    bool isAudioBottle = bottle.audioUrl.isNotEmpty;

    // 定义渐变背景颜色
    List<Color> getGradientColors() {
      if (isAudioBottle) {
        return [const Color(0xFFFF8C61), const Color(0xFFFF6B6B), const Color(0xFFFF5F6D)];
      } else {
        return [const Color(0xFF4FACFE), const Color(0xFF00F2FE), const Color(0xFF00DBDE)];
      }
    }

    return GestureDetector(
      onTap: () async {
        Get.to(
          () => BottleCardDetail(
              id: bottle.id,
              imageUrl: bottle.imageUrl.isEmpty ? 'https://picsum.photos/500/800' : bottle.imageUrl,
              title: bottle.title.isNotEmpty ? bottle.title : "暂无标题",
              content: bottle.content,
              createdAt: bottle.createdAt,
              audioUrl: bottle.audioUrl,
              user: bottle.user,
              views: bottle.views,
              resonates: bottle.resonates,
              favorites: bottle.favorites,
              shares: bottle.shares,
              isResonated: bottle.isResonated,
              isFavorited: bottle.isFavorited,
              mood: bottle.mood),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 背景
            if (isImageBottle)
              Image.network(
                bottle.imageUrl.isEmpty ? 'https://picsum.photos/500/800' : bottle.imageUrl,
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
                  child: Icon(isAudioBottle ? Icons.audiotrack : Icons.format_quote_rounded, size: 48, color: Colors.white.withOpacity(0.3)),
                ),
              ),

            // 渐变遮罩
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.2), Colors.black.withOpacity(0.5), Colors.black.withOpacity(0.8)],
                  stops: const [0.3, 0.5, 0.7, 1.0],
                ),
              ),
            ),

            // 内容
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 用户信息行
                  Row(
                    children: [
                      // 头像
                      CacheUserAvatar(avatarUrl: bottle.user.avatar, size: 32),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          bottle.user.nickname,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500, shadows: [Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black)]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // 标题
                  Text(
                    bottle.title.isNotEmpty ? bottle.title : bottle.mood,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, shadows: [Shadow(offset: Offset(1, 1), blurRadius: 3, color: Colors.black)]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // 底部数据栏
                  Row(
                    children: [
                      Icon(Icons.remove_red_eye, size: 16, color: Colors.white.withOpacity(0.9)),
                      const SizedBox(width: 4),
                      Text('${bottle.views}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            shadows: const [Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black)],
                          )),
                      const Spacer(),
                      // 修改这里：用点赞图标和数值替换热度值
                      GestureDetector(
                        onTap: () {
                          squareController.updateBottleResonateStatus(bottle.id, isResonated: !bottle.isResonated, resonates: bottle.resonates);
                          print("数据更新了------------------------> ${bottle.isResonated}");
                        },
                        child: Row(
                          children: [
                            Icon(bottle.isResonated ? Icons.favorite : Icons.favorite_border, size: 16, color: bottle.isResonated ? Colors.red : Colors.white.withOpacity(0.9)),
                            const SizedBox(width: 4),
                            Text('${bottle.resonates}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                  shadows: const [Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black)],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 类型标识 - 右上角
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isImageBottle
                          ? Icons.image
                          : isAudioBottle
                              ? Icons.audiotrack
                              : Icons.text_fields,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isImageBottle
                          ? '图片'
                          : isAudioBottle
                              ? '语音'
                              : '文字',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
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
