import 'package:fangkong_xinsheng/app/pages/square/model/bottle_card.dart';
import 'package:fangkong_xinsheng/app/pages/views/controller/view_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:fangkong_xinsheng/app/pages/square/views/bottle_card_detail.dart';
import 'package:fangkong_xinsheng/app/pages/square/controller/square_controller.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/view_history.dart';

class SquarePage extends StatefulWidget {
  const SquarePage({Key? key}) : super(key: key);

  @override
  State<SquarePage> createState() => _SquarePageState();
}

class _SquarePageState extends State<SquarePage> {
  final CardSwiperController controller = CardSwiperController();
  final squareController = Get.put(SquareController());
  final viewHistoryController = Get.put(ViewHistoryController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.withOpacity(0.3),
              Colors.purple.withOpacity(0.2),
              Colors.pink.withOpacity(0.15),
            ],
            stops: const [0.2, 0.6, 0.9],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -50,
              right: -30,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.purple.withOpacity(0.2),
                      Colors.transparent
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  // 导航栏 普通的即可
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // logo

                        Text(
                          'nav_square'.tr,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        // 消息通知
                        const Icon(Icons.notifications),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  // 顶部故事栏
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 4,
                      itemBuilder: (context, index) => _buildStoryItem(index),
                    ),
                  ),

                  // 卡片区域
                  Expanded(
                    child: Obx(() {
                      if (squareController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return CardSwiper(
                        controller: controller,
                        cardsCount: squareController.bottles.length,
                        isLoop: false,
                        backCardOffset: const Offset(25, 25),
                        padding: const EdgeInsets.all(24.0),
                        scale: 0.95,
                        numberOfCardsDisplayed: 3,
                        onEnd: () {
                          squareController.fetchRandomBottles();
                        },
                        cardBuilder: (BuildContext context,
                            int index,
                            int horizontalOffsetPercentage,
                            int verticalOffsetPercentage) {
                          final bottle = squareController.bottles[index];
                          return _buildCard(
                            bottle: bottle,
                            title: bottle.title.isNotEmpty
                                ? bottle.title
                                : bottle.mood,
                            content: bottle.content,
                            time: bottle.createdAt,
                            location: '查看次数: ${bottle.views}',
                            imageUrl: bottle.imageUrl.isEmpty
                                ? 'https://picsum.photos/500/800'
                                : bottle.imageUrl,
                            audioUrl: bottle.audioUrl,
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryItem(int index) {
    final items = [
      {'title': 'Your Story', 'image': 'assets/images/avatar.jpg'},
      {'title': 'miarulhaq', 'image': 'https://picsum.photos/100/100?random=1'},
      {
        'title': 'halofellas',
        'image': 'https://picsum.photos/100/100?random=2'
      },
      {'title': 'fmaotan', 'image': 'https://picsum.photos/100/100?random=3'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.5),
                  Colors.orange.withOpacity(0.5),
                ],
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
                image: DecorationImage(
                  image: NetworkImage(items[index]['image']!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            items[index]['title']!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required BottleCardModel bottle,
    required String title,
    required String content,
    required String time,
    required String location,
    required String imageUrl,
    String? audioUrl,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => BottleCardDetail(
            imageUrl: imageUrl,
            title: title,
            content: content,
            time: time,
            audioUrl: audioUrl,
            user: UserInfo(
              id: bottle.user.id,
              sex: bottle.user.sex,
              nickname: bottle.user.nickname,
              avatar: bottle.user.avatar,
            ),
          ),
          transition: Transition.cupertino,
        );
        // 创建浏览历史记录
        viewHistoryController.createViewHistory(bottle.id);
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 背景片
            // Hero
            Hero(
              tag: 'bottle_card_image_$imageUrl',
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
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
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),

            // 内容
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white70,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // 关闭按钮
            Positioned(
              right: 16,
              bottom: 16,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    controller.swipe(CardSwiperDirection.left);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _onSwipe(
      int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    print(
        'Card swiped from index $previousIndex to $currentIndex in direction $direction');
    return true;
  }
}
