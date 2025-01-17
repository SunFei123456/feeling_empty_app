
import 'package:fangkong_xinsheng/app/pages/views/topic_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/views/controller/topic_controller.dart';

class HotTopicsWidget extends StatelessWidget {
  final TopicController controller = Get.find<TopicController>();

  HotTopicsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'trending_topics'.tr,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
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
                  onTap: () {
                    Get.to(
                      () => TopicDetailPage(
                        topicId: topic.id,
                        topicName: "1",
                        bottleCount:1
                      ),
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue[400]!.withOpacity(0.8),
                          Colors.purple[300]!.withOpacity(0.6),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 15,
                          left: 15,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '#${topic.title}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${topic.contentCount}条内容',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
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
