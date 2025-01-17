import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:fangkong_xinsheng/app/pages/views/controller/view_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/controller/bottle_controller.dart';
import 'package:fangkong_xinsheng/app/pages/square/views/bottle_card_detail.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/view_history.dart';

class HotBottlesPage extends GetView<BottleController> {
  const HotBottlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Get.put(BottleController());

    controller.loadDayHotBottles(); // 默认加载24小时热门

    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'hot_bottles'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            labelColor: isDarkMode ? Colors.white : Colors.black,
            unselectedLabelColor: Colors.grey[400],
            labelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
            indicatorColor: isDarkMode ? Colors.white : Colors.black,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            onTap: (index) {
              switch (index) {
                case 0:
                  controller.loadDayHotBottles();
                  break;
                case 1:
                  controller.loadWeekHotBottles();
                  break;
                case 2:
                  controller.loadMonthHotBottles();
                  break;
              }
            },
            tabs:  [
              Tab(text: 'trending_24h'.tr),
              Tab(text: 'trending_week'.tr),
              Tab(text: 'trending_month'.tr),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(), // 禁用滑动
          children: [
            _buildBottleGrid('day'),
            _buildBottleGrid('week'),
            _buildBottleGrid('month'),
          ],
        ),
      ),
    );
  }

  Widget _buildBottleGrid(String timeRange) {
    return Obx(() {
      if (controller.isLoadingHotBottles.value &&
          controller.hotBottles.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return RefreshIndicator(
        onRefresh: () {
          switch (timeRange) {
            case 'day':
              return controller.loadDayHotBottles();
            case 'month':
              return controller.loadMonthHotBottles();
            default:
              return controller.loadWeekHotBottles();
          }
        },
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.6,
          ),
          itemCount: controller.hotBottles.length,
          itemBuilder: (context, index) {
            final bottle = controller.hotBottles[index];
            return _buildHotBottleCard(bottle);
          },
        ),
      );
    });
  }

  Widget _buildHotBottleCard(BottleModel bottle) {
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
      onTap: () async {
        Get.to(
          () => BottleCardDetail(
            id: bottle.id,
            imageUrl: bottle.imageUrl.isEmpty
                ? 'https://picsum.photos/500/800'
                : bottle.imageUrl,
            title: bottle.title.isNotEmpty ? bottle.title : "暂无标题",
            content: bottle.content,
            createdAt: bottle.createdAt,
            audioUrl: bottle.audioUrl,
            user: bottle.user,
            views: bottle.views,
            resonates: bottle.resonates,
          ),
        );

        try {
          final viewHistoryController = Get.put(ViewHistoryController());
          await viewHistoryController.createViewHistory(bottle.id);
        } catch (e) {
          print('创建浏览历史记录失败: $e');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 背景
              if (isImageBottle)
                Image.network(
                  bottle.imageUrl.isEmpty
                      ? 'https://picsum.photos/500/800'
                      : bottle.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
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
                      isAudioBottle
                          ? Icons.audiotrack
                          : Icons.format_quote_rounded,
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
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.3, 0.5, 0.7, 1.0],
                  ),
                ),
              ),

              // 内容
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // 类型标识和标题行
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
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
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            bottle.title.isNotEmpty
                                ? bottle.title
                                : bottle.mood,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 底部数据栏
                    Row(
                      children: [
                        Icon(Icons.remove_red_eye,
                            size: 16, color: Colors.white.withOpacity(0.9)),
                        const SizedBox(width: 4),
                        Text(
                          '${bottle.views}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            shadows: const [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // 热度值
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.withOpacity(0.9),
                                Colors.red.withOpacity(0.9),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.local_fire_department,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${bottle.resonates}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
  }
}
