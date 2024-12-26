import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:ui' show lerpDouble;

class BottlePage extends StatelessWidget {
  const BottlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景渐变
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).brightness == Brightness.light
                      ? const Color(0xFFE3F2FD)
                      : const Color(0xFF1A237E),
                  Theme.of(context).brightness == Brightness.light
                      ? const Color(0xFFBBDEFB)
                      : const Color(0xFF0D47A1),
                ],
              ),
            ),
          ),

          // 主内容
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 自定义头部
              SliverPersistentHeader(
                pinned: true,
                delegate: _BottleHeaderDelegate(),
              ),

              // 内容区域
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // 海洋动画区域
                      const SizedBox(height: 20),
                      _buildOceanAnimation(),
                      const SizedBox(height: 30),

                      // 漂流瓶类型选择
                      _buildBottleTypes(context),
                      const SizedBox(height: 30),

                      // 最近的漂流瓶
                      _buildRecentBottles(context),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 投放漂流瓶按钮
          Positioned(
            bottom: 100,
            right: 30,
            child: _buildThrowButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildOceanAnimation() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.waves,
                        size: 50,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'bottle_ocean_title'.tr + ' ${index + 1}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (i) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == index
                              ? Colors.blue[700]
                              : Colors.blue[700]?.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottleTypes(BuildContext context) {
    final types = [
      {'icon': Icons.text_fields, 'label': 'bottle_type_text'.tr},
      {'icon': Icons.image, 'label': 'bottle_type_image'.tr},
      {'icon': Icons.mic, 'label': 'bottle_type_voice'.tr},
    ];

    return AnimationLimiter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          types.length,
          (index) => AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildTypeCard(
                  context,
                  types[index]['icon'] as IconData,
                  types[index]['label'] as String,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeCard(BuildContext context, IconData icon, String label) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBottles(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'recent_bottles'.tr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        AnimationLimiter(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _buildBottleCard(context, index),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottleCard(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            // 处理点击事件
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBottleIcon(index),
                const SizedBox(height: 12),
                Text(
                  'bottle_message_title'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'bottle_message_preview'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottleIcon(int index) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.pink,
    ];

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: colors[index % colors.length].withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.mail_outline,
        color: colors[index % colors.length],
      ),
    );
  }

  Widget _buildThrowButton(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            // 处理投放漂流瓶
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  'throw_bottle'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottleHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // 计算滚动进度 (0.0 到 1.0)
    final progress = shrinkOffset / maxExtent;

    // 根据滚动进度计算标题位置和大小
    final fontSize = lerpDouble(28, 20, progress) ?? 28;
    final paddingLeft = lerpDouble(16, 16, progress) ?? 10;

    return Container(
      decoration: BoxDecoration(
        color: shrinkOffset > 0 ? Colors.white : Colors.transparent,
        // 添加底部阴影
        boxShadow: [
          if (shrinkOffset > 0)
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2)),
        ],
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.only(left: paddingLeft, bottom: 10),
          child: Text(
            'bottle_title'.tr,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 100.0;

  @override
  double get minExtent => 80.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
