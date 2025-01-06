import 'package:fangkong_xinsheng/app/pages/square/views/bottle_card_detail.dart';
import 'package:fangkong_xinsheng/app/router/index.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fangkong_xinsheng/app/pages/views/controller/view_history_controller.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/view_history.dart';
import 'package:fangkong_xinsheng/app/widgets/confirm_dialog.dart';

class ViewHistoryPage extends GetView<ViewHistoryController> {
  ViewHistoryPage() {
    // 确保控制器已经被初始化
    Get.put(ViewHistoryController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '浏览记录',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline_rounded),
            onPressed: () => {
              ConfirmDialog.show(
                title: '删除确认',
                content: '确定要删除所有浏览记录吗？',
                confirmText: '确认',
                cancelText: '取消',
                onConfirm: () {
                  Get.find<ViewHistoryController>().clearHistory();
                },
              ),
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.historyItems.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          );
        }

        if (controller.historyItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_rounded, size: 64, color: Colors.grey[300]),
                SizedBox(height: 16),
                Text(
                  '暂无浏览记录',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    '共 ${controller.totalItems} 条记录',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.loadViewHistory(refresh: true),
                color: Theme.of(context).primaryColor,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: controller.historyItems.length,
                  itemBuilder: (context, index) {
                    if (index == controller.historyItems.length - 1) {
                      controller.loadViewHistory();
                    }
                    return HistoryCard(item: controller.historyItems[index]);
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final ViewHistoryItem item;
  const HistoryCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        child: InkWell(
          // 长按显示底部菜单
          onLongPress: () => showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 顶部拖动条
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // 操作按钮
                  ListTile(
                    leading: Icon(Icons.delete_outline, color: Colors.red),
                    title: const Text(
                      '删除记录',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      ConfirmDialog.show(
                        title: '删除确认',
                        content: '确定要删除这条浏览记录吗？',
                        confirmText: '删除',
                        cancelText: '取消',
                        onConfirm: () {
                          Get.find<ViewHistoryController>()
                              .deleteViewHistory(item.id);
                        },
                      );
                    },
                  ),
                  // 底部安全区域
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
          // 点击进入漂流瓶详情页
          onTap: () => Get.to(
            () => BottleCardDetail(
              bottleId: item.id,
              imageUrl: item.imageUrl,
              title: item.title,
              content: item.content,
              time: item.createdAt.toString(),
              audioUrl: item.audioUrl,
            ),
            transition: Transition.cupertino,
            arguments: item.id,
          ),
          child: Stack(
            children: [
              // 背景图片
              AspectRatio(
                aspectRatio: 2 / 1,
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: frame != null
                          ? child
                          : Container(
                              color: Colors.grey[100],
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[100],
                    child: Center(
                      child: Icon(
                        Icons.broken_image_rounded,
                        color: Colors.grey[400],
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              // 渐变遮罩
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              // 内容
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(item.user.avatar),
                          backgroundColor: Colors.black26,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.user.nickname,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        _buildMoodChip(item.mood),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.content.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Text(
                        item.content,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.remove_red_eye_outlined,
                            size: 16, color: Colors.white70),
                        SizedBox(width: 4),
                        Text(
                          '${item.views}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.favorite_border_rounded,
                            size: 16, color: Colors.white70),
                        SizedBox(width: 4),
                        Text(
                          '${item.resonances}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Spacer(),
                        Text(
                          _formatDate(item.createdAt),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
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

  Widget _buildMoodChip(String mood) {
    final moodColors = {
      'happy': Colors.green,
      'excited': Colors.orange,
      // 添加更多心情对应的颜色
    };

    final color = moodColors[mood] ?? Colors.blue;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        mood,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '今天';
    } else if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${date.month}月${date.day}日';
    }
  }
}
