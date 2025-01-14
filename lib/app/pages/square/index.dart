import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:fangkong_xinsheng/app/pages/views/controller/view_history_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:fangkong_xinsheng/app/pages/square/views/bottle_card_detail.dart';
import 'package:fangkong_xinsheng/app/pages/square/controller/square_controller.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/view_history.dart';

class SquarePage extends StatefulWidget {
  const SquarePage({super.key});

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
                        return const Center(
                            child: CupertinoActivityIndicator());
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
      {'id': 1, 'name': '梦想海域', 'bg': 'https://picsum.photos/100/100?random=1'},
      {'id': 2, 'name': '希望之海', 'bg': 'https://picsum.photos/100/100?random=2'},
      {'id': 3, 'name': '宁静港湾', 'bg': 'https://picsum.photos/100/100?random=3'},
      {'id': 4, 'name': '勇气之渊', 'bg': 'https://picsum.photos/100/100?random=5'},
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
                  Colors.orange.withOpacity(0.5)
                ],
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
                image: DecorationImage(
                  image: NetworkImage(items[index]['bg'] as String),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            items[index]['name'] as String,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required BottleModel bottle}) {
    // 判断瓶子类型
    bool isImageBottle = bottle.imageUrl.isNotEmpty;
    bool isAudioBottle = bottle.audioUrl.isNotEmpty;

    // 定义渐变背景颜色
    List<Color> getGradientColors() {
      if (isAudioBottle) {
        // 音频：暖色调渐变
        return [
          const Color(0xFFFF8C61), // 珊瑚色
          const Color(0xFFFF6B6B), // 粉红色
          const Color(0xFFFF5F6D), // 玫瑰色
        ];
      } else {
        // 纯文本：冷色调渐变
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
            imageUrl: bottle.imageUrl,
            title: bottle.title,
            content: bottle.content,
            createdAt: bottle.createdAt,
            audioUrl: bottle.audioUrl,
            user: UserInfo(
              id: bottle.user.id,
              sex: bottle.user.sex,
              nickname: bottle.user.nickname,
              avatar: bottle.user.avatar,
            ),
            views: bottle.views,
            resonates: bottle.resonates,
            favorites: bottle.favorites,
            shares: bottle.shares,
            isResonated: bottle.isResonated,
            isFavorited: bottle.isFavorited,
          ),
          transition: Transition.cupertino,
        );
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
            // 背景
            if (isImageBottle)
              // 图片背景
              Hero(
                tag: 'bottle_card_image_${bottle.imageUrl}',
                child: Image.network(
                  bottle.imageUrl,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
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
                  // 类型标识和标题
                  Row(
                    children: [
                      // 类型图标
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
                      // 标题
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            bottle.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // 关闭按钮
            Positioned(
              right: 16,
              top: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
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
