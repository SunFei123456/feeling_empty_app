
import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/controller/bottle_controller.dart';
import 'package:fangkong_xinsheng/app/pages/square/views/bottle_card_detail.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/view_history.dart';

class HotBottlesPage extends GetView<BottleController> {
  const HotBottlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BottleController());
    controller.loadDayHotBottles(); // 默认加载24小时热门

    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '热门漂流瓶',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey[400],
            labelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
            indicatorColor: Colors.black,
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
            tabs: const [
              Tab(text: '24小时热门'),
              Tab(text: '本周热门'),
              Tab(text: '本月热门'),
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
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.8,
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
    return GestureDetector(
      onTap: () {
        Get.to(
          () => BottleCardDetail(
            id: bottle.id,
            imageUrl: bottle.imageUrl.isEmpty
                ? 'https://picsum.photos/500/800'
                : bottle.imageUrl,
            title: bottle.title.isNotEmpty ? bottle.title : bottle.mood,
            content: bottle.content,
            createdAt: bottle.createdAt,
            audioUrl: bottle.audioUrl,
            user: UserInfo(
              id: bottle.user.id,
              nickname: bottle.user.nickname,
              avatar: bottle.user.avatar,
              sex: bottle.user.sex,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[900],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 背景图片
              Image.network(
                bottle.imageUrl.isEmpty
                    ? 'https://picsum.photos/500/800'
                    : bottle.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[800],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[800],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
              // 渐变遮罩
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              // 内容
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      bottle.title.isNotEmpty ? bottle.title : bottle.mood,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // 浏览量
                        Icon(Icons.remove_red_eye,
                            size: 14, color: Colors.white.withOpacity(0.8)),
                        const SizedBox(width: 4),
                        Text(
                          '${bottle.views}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        // 热度值
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.withOpacity(0.8),
                                Colors.red.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.local_fire_department,
                                color: Colors.white,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${(bottle.views * 0.8).toStringAsFixed(1)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
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
