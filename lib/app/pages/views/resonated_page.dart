import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/view_history.dart';
import 'package:fangkong_xinsheng/app/pages/views/api/user_bottles_api.dart';
import 'package:fangkong_xinsheng/app/widgets/common_bottle_card.dart';

class ResonatedPage extends StatefulWidget {
  @override
  State<ResonatedPage> createState() => _ResonatedPageState();
}

class _ResonatedPageState extends State<ResonatedPage> {
  final _api = BottleInteractionApiService();
  final List<BottleModel> resonatedItems = [];
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
        Get.snackbar('提示', response.message ?? '获取共鸣列表失败');
      }
    } catch (e) {
      Get.snackbar('提示', '获取共鸣列表失败');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'my_resonance'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: isLoading && resonatedItems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : resonatedItems.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
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
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.favorite_rounded,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '共 ${resonatedItems.length} 条共鸣',
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
                        onRefresh: () => _loadResonatedItems(refresh: true),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          itemCount: resonatedItems.length,
                          itemBuilder: (context, index) {
                            final item = resonatedItems[index];
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
          Icon(Icons.favorite_border, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
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
}
