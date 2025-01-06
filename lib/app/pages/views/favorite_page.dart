import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/square/views/bottle_card_detail.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/view_history.dart';
import 'package:fangkong_xinsheng/app/pages/views/api/user_bottles_api.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final _api = BottleInteractionApiService();
  final List<ViewHistoryItem> favorites = [];
  bool isLoading = false;
  int currentPage = 1;
  bool hasMore = true;
  static const pageSize = 10;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites({bool refresh = false}) async {
    if (isLoading || (!hasMore && !refresh)) return;

    if (refresh) {
      currentPage = 1;
      favorites.clear();
      hasMore = true;
    }

    setState(() => isLoading = true);
    try {
      final response = await _api.getFavoritedBottles(
        page: currentPage,
        pageSize: pageSize,
      );
      
      if (response.success) {
        final newItems = response.data ?? [];
        if (newItems.isEmpty) {
          hasMore = false;
        } else {
          favorites.addAll(newItems);
          currentPage++;
        }
      } else {
        Get.snackbar('错误', response.message ?? '获取收藏列表失败');
      }
    } catch (e) {
      Get.snackbar('错误', '获取收藏列表失败');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的收藏'),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : favorites.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadFavorites,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final item = favorites[index];
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
          Icon(Icons.bookmark_border, size: 64, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            '暂无收藏内容',
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
            imageUrl: item.imageUrl.isEmpty 
                ? 'https://picsum.photos/500/800'  // 默认图片
                : item.imageUrl,
            title: item.title,
            content: item.content,
            time: _formatDate(item.createdAt),  // 添加日期格式化
            audioUrl: item.audioUrl,
            user: item.user,
            resonateCount: item.resonances,
            // 可以添加更多状态
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片部分
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                item.imageUrl.isEmpty 
                    ? 'https://picsum.photos/500/800'  // 默认图片
                    : item.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                // 添加加载状态
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / 
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                // 添加错误处理
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                    ),
                  );
                },
              ),
            ),
            // 内容部分
            Padding(
              padding: EdgeInsets.all(16),
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
                        radius: 16,
                        backgroundImage: NetworkImage(item.user.avatar),
                      ),
                      SizedBox(width: 8),
                      Text(
                        item.user.nickname,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.favorite, size: 16, color: Colors.red),
                      SizedBox(width: 4),
                      Text(
                        '${item.resonances}',
                        style: TextStyle(
                          fontSize: 14,
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