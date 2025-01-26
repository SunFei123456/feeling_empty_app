// 搜索话题页

import 'dart:async';

import 'package:fangkong_xinsheng/app/router/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/views/api/topic_api.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/topic.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/topic_detail.dart';
import 'package:fangkong_xinsheng/app/pages/views/controller/topic_controller.dart';

class SearchTopicPage extends StatefulWidget {
  const SearchTopicPage({super.key});

  @override
  State<SearchTopicPage> createState() => _SearchTopicPageState();
}

class _SearchTopicPageState extends State<SearchTopicPage> {
  final _searchController = TextEditingController();
  final _topicController = Get.find<TopicController>();
  final _debouncer = Debouncer(milliseconds: 500);
  bool _isLoading = false;
  List<Topic> _searchResults = [];
  List<Topic> _hotTopics = [];

  @override
  void initState() {
    super.initState();
    _loadHotTopics();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHotTopics() async {
    setState(() => _isLoading = true);
    try {
      final response = await TopicApiService().getHotTopics(10);
      if (response.success && response.data != null) {
        setState(() => _hotTopics = response.data!);
      }
    } catch (e) {
      print('Load hot topics error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _searchTopics(String keyword) async {
    if (keyword.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await TopicApiService().searchTopics(keyword);
      if (response.success && response.data != null) {
        setState(() => _searchResults = response.data!);
      }
    } catch (e) {
      print('Search topics error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        title: Text(
          '话题',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // 搜索框
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  _debouncer.run(() => _searchTopics(value));
                },
                decoration: InputDecoration(
                    hintText: '搜索你感兴趣的话题',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey[600] : Colors.grey[400],
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark ? Colors.grey[600] : Colors.grey[400],
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
            ),
          ),

          // 搜索结果或热门话题
          Expanded(
            child: _isLoading
                ? const Center(child: CupertinoActivityIndicator())
                : _searchController.text.isEmpty
                    ? _buildHotTopics(isDark)
                    : _buildSearchResults(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildHotTopics(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '推荐话题',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _hotTopics.length,
            separatorBuilder: (context, index) => Divider(color: isDark ? Colors.grey[800] : Colors.grey[200]),
            itemBuilder: (context, index) {
              final topic = _hotTopics[index];
              return _buildTopicItem(topic, isDark);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(bool isDark) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => Divider(
        color: isDark ? Colors.grey[800] : Colors.grey[200],
      ),
      itemBuilder: (context, index) {
        final topic = _searchResults[index];
        return _buildTopicItem(topic, isDark);
      },
    );
  }

  Widget _buildTopicItem(Topic topic, bool isDark) {
    return InkWell(
      onTap: () {
        AppRoutes.to(AppRoutes.TOPIC_DETAIL, arguments: topic.id);
        _topicController.addTopicView(topic.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // 话题图标或封面
            if (topic.bgImage.isNotEmpty)
              ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(topic.bgImage, width: 60, height: 60, fit: BoxFit.cover))
            else
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: isDark ? Colors.grey[800] : Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.tag, color: isDark ? Colors.grey[600] : Colors.grey[400]),
              ),
            const SizedBox(width: 12),

            // 话题信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('# ${topic.title}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black)),
                  const SizedBox(height: 4),
                  Text('${topic.views}人围观', style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[600])),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? Colors.grey[600] : Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

// 防抖器
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
