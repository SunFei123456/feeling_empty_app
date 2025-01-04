import 'package:fangkong_xinsheng/app/pages/square/views/bottle_card_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopicDetailPage extends StatelessWidget {
  final String topicName;
  final int bottleCount;

  const TopicDetailPage({
    Key? key,
    required this.topicName,
    required this.bottleCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 顶部 SliverAppBar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                topicName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue[400]!,
                      Colors.purple[300]!,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // 装饰性元素
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    // 话题信息
                    Positioned(
                      left: 20,
                      bottom: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.tag,
                                color: Colors.white.withOpacity(0.8),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$bottleCount 条内容',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
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
          ),

          // 内容区域
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // 模拟数据
                  final bottleData = {
                    'title': '${topicName}下的作品 ${index + 1}',
                    'subtitle': '这是一段关于${topicName}的故事...',
                    'time': '2024-03-${10 + index}',
                    'location': '来自未知的海域',
                    'imageUrl': 'https://picsum.photos/500/800?random=$index',
                    'author': '用户${index + 1}',
                    'likes': (100 + index * 10).toString(),
                  };

                  return _buildBottleCard(context, bottleData);
                },
                childCount: 10, // 显示10个作品
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottleCard(BuildContext context, Map<String, String> bottleData) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => BottleCardDetail(
            imageUrl: bottleData['imageUrl']!,
            title: bottleData['title']!,
            content: bottleData['subtitle']!,
            time: bottleData['time']!,
          ),
          transition: Transition.fadeIn,
        );
      },
      child: Container(
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
            // 图片
            Expanded(
              child: Hero(
                tag: 'bottle_card_image_${bottleData['imageUrl']}',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(bottleData['imageUrl']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            // 内容
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bottleData['title']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.blue[100],
                        child: Text(
                          bottleData['author']![0],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          bottleData['author']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.favorite,
                        size: 12,
                        color: Colors.red[300],
                      ),
                      const SizedBox(width: 2),
                      Text(
                        bottleData['likes']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
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
    );
  }
} 