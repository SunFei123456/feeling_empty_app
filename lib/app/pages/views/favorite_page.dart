import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/view_history.dart';
import 'package:fangkong_xinsheng/app/pages/views/api/user_bottles_api.dart';
import 'package:fangkong_xinsheng/app/widgets/common_bottle_card.dart';

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
        Get.snackbar('提示', response.message ?? '获取收藏列表失败');
      }
    } catch (e) {
      Get.snackbar('提示', '获取收藏列表失败');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '我的收藏',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: isLoading && favorites.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    // 顶部统计栏
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.bookmark_rounded,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '共 ${favorites.length} 条收藏',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 列表内容
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => _loadFavorites(refresh: true),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemCount: favorites.length,
                          itemBuilder: (context, index) {
                            final item = favorites[index];
                            return CommonBottleCard(bottle: item);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
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
} 