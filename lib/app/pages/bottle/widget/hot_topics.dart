import 'package:fangkong_xinsheng/app/pages/views/topic_detail_page.dart';
import 'package:fangkong_xinsheng/app/router/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/views/controller/topic_controller.dart';

class HotTopicsWidget extends StatelessWidget {
  final TopicController controller = Get.find<TopicController>();

  HotTopicsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Get.isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 标题 推荐话题
            Text('trending_topics'.tr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white70 : Colors.black87)),
            // 查看更多
            GestureDetector(
              onTap: () => AppRoutes.to(AppRoutes.SEARCH_TOPIC),
              child: Row(
                children: [
                  Text('view_more'.tr, style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.white70 : Colors.black87)),
                  Icon(Icons.arrow_forward_ios, size: 12, color: isDarkMode ? Colors.white70 : Colors.black87),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 120,
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.hotTopics.length,
              itemBuilder: (context, index) {
                final topic = controller.hotTopics[index];
                return GestureDetector(
                  onTap: () => {
                    AppRoutes.to(AppRoutes.TOPIC_DETAIL, arguments: topic.id),
                    // ZEN: 增加话题浏览量
                    controller.addTopicView(topic.id),
                  },
                  child: Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(image: NetworkImage(topic.bgImage), fit: BoxFit.cover)),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 15,
                          left: 15,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('#${topic.title}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('共${topic.views}人围观', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
