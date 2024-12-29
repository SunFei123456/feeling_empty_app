import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../controller.dart';
import 'post_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PostList extends GetView<TimePostOfficeController> {
  const PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimationLimiter(
      child: MasonryGridView.count(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemCount: controller.posts.length,
        itemBuilder: (context, index) {
          final post = controller.posts[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: 2,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: PostCard(
                  title: post['title'],
                  author: post['author'],
                  imageUrl: post['imageUrl'],
                  content: post['content'],
                  letterContent: post['letterContent'],
                  isLocked: post['isLocked'] ?? false,
                  unlockTime: post['unlockTime'] ?? '',
                  type: post['type'] ?? '',
                  category: post['category'] ?? '',
                  createdAt: post['createdAt'] ?? '',
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
} 