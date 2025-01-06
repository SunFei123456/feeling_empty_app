import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/square/views/bottle_card_detail.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/view_history.dart';
import 'package:fangkong_xinsheng/app/pages/views/api/user_bottles_api.dart';

class ResonatedPage extends StatefulWidget {
  @override
  State<ResonatedPage> createState() => _ResonatedPageState();
}

class _ResonatedPageState extends State<ResonatedPage> {
  final _api = BottleInteractionApiService();
  final List<ViewHistoryItem> resonatedItems = [];
  bool isLoading = false;
  int currentPage = 1;
  bool hasMore = true;
  static const pageSize = 20;

  @override
  void initState() {
    super.initState();
    _loadResonatedItems();
  }

  Future<void> _loadResonatedItems({bool refresh = false}) async {
    if (isLoading || (!hasMore && !refresh)) return;

    if (refresh) {
      currentPage = 1;
      resonatedItems.clear();
      hasMore = true;
    }

    setState(() => isLoading = true);
    try {
      final response = await _api.getResonatedBottles(
        page: currentPage,
        pageSize: pageSize,
      );
      
      if (response.success) {
        final newItems = response.data ?? [];
        if (newItems.isEmpty) {
          hasMore = false;
        } else {
          resonatedItems.addAll(newItems);
          currentPage++;
        }
      } else {
        Get.snackbar('错误', response.message ?? '获取共鸣列表失败');
      }
    } catch (e) {
      Get.snackbar('错误', '获取共鸣列表失败');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的共鸣'),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : resonatedItems.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadResonatedItems,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: resonatedItems.length,
                    itemBuilder: (context, index) {
                      final item = resonatedItems[index];
                      return _buildBottleCard(item);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            '暂无共鸣内容',
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

  Widget _buildBottleCard(ViewHistoryItem item) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => Get.to(
          () => BottleCardDetail(
            bottleId: item.id,
            imageUrl: item.imageUrl,
            title: item.title,
            content: item.content,
            time: item.createdAt.toString(),
            audioUrl: item.audioUrl,
            user: item.user,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 缩略图
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              // 内容部分
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      item.content,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(item.user.avatar),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.user.nickname,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          _formatDate(item.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
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