import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/time_post_office/views/post_detail_page.dart';

class PostCard extends StatelessWidget {
  final String title;
  final String author;
  final String? imageUrl;
  final String content;
  final String letterContent;
  final bool isLocked;
  final String unlockTime;
  final String type;
  final String category;
  final String createdAt;
  final bool isTop;

  const PostCard({
    Key? key,
    required this.title,
    required this.author,
    this.imageUrl,
    required this.content,
    required this.isLocked,
    required this.unlockTime,
    required this.type,
    required this.category,
    required this.createdAt,
    required this.letterContent,
    this.isTop = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => Get.to(() => PostDetailPage(post: {
            'title': title,
            'author': author,
            'imageUrl': imageUrl,
            'content': content,
            'letterContent': letterContent,
            'type': type,
            'category': category,
            'unlockTime': unlockTime,
            'isLocked': isLocked,
            'createdAt': createdAt,
          })),
      onLongPress: () {
        Get.bottomSheet(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 删除选项
                ListTile(
                  leading: Icon(
                    Icons.delete_outline,
                    color: Colors.red[400],
                  ),
                  title: Text(
                    '删除',
                    style: TextStyle(
                      color: Colors.red[400],
                    ),
                  ),
                  onTap: () {
                    Get.back();
                    Get.dialog(
                      AlertDialog(
                        backgroundColor:
                            isDark ? const Color(0xFF1A1A1A) : Colors.white,
                        title: Text(
                          '确认删除',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        content: Text(
                          '确定要删除这封信吗？删除后无法恢复。',
                          style: TextStyle(
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              '取消',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: 处理删除逻辑
                              Get.back();
                              Get.snackbar(
                                '提示',
                                '删除成功',
                                backgroundColor: Colors.green[100],
                                colorText: Colors.green[900],
                                icon: const Icon(Icons.check_circle,
                                    color: Colors.green),
                              );
                            },
                            child: Text(
                              '删除',
                              style: TextStyle(
                                color: Colors.red[400],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // 置顶选项
                ListTile(
                  leading: const Icon(Icons.push_pin_outlined),
                  title: Text(
                    isTop ? '取消置顶' : '置顶',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  onTap: () {
                    Get.back();
                    // TODO: 处理置顶逻辑
                    Get.snackbar(
                      '提示',
                      isTop ? '已取消置顶' : '已置顶',
                      backgroundColor: Colors.green[100],
                      colorText: Colors.green[900],
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                    );
                  },
                ),
                // 底部安全区域
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shadowColor: isDark ? Colors.black26 : Colors.black12,
        color: isDark ? const Color(0xFF242424) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // 类型标签
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        type,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (content.isNotEmpty)
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                        height: 1.5,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor:
                            isDark ? Colors.blue[900] : Colors.blue[100],
                        child: Text(
                          author[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.blue[100] : Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        author,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        createdAt,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[600] : Colors.grey[500],
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
