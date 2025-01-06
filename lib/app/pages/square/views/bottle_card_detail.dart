import 'dart:ui';

import 'package:fangkong_xinsheng/app/pages/profile/views/profile_page.dart';
import 'package:fangkong_xinsheng/app/pages/square/model/bottle_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/view_history.dart';
import 'package:fangkong_xinsheng/app/widgets/audio_player_widget.dart';
import 'package:dio/dio.dart';
import 'package:fangkong_xinsheng/app/pages/square/api/index.dart';
import 'package:fangkong_xinsheng/app/core/services/api_service.dart';
import 'package:fangkong_xinsheng/app/pages/views/api/user_bottles_api.dart';

class BottleCardDetail extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String content;
  final String time;
  final String? audioUrl;
  final UserInfo? user;
  final int bottleId;
  final bool isResonated;
  final bool isFavorited;
  final int resonateCount;

  const BottleCardDetail({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.content,
    this.user,
    required this.time,
    this.audioUrl,
    required this.bottleId,
    this.isResonated = false,
    this.isFavorited = false,
    this.resonateCount = 0,
  }) : super(key: key);

  @override
  State<BottleCardDetail> createState() => _BottleCardDetailState();
}

class _BottleCardDetailState extends State<BottleCardDetail> {
  final _api = BottleInteractionApiService();
  late bool _isResonated;
  late bool _isFavorited;
  late int _resonateCount;

  @override
  void initState() {
    super.initState();
    _isResonated = widget.isResonated;
    _isFavorited = widget.isFavorited;
    _resonateCount = widget.resonateCount;
  }

  Future<void> _handleResonate() async {
    try {
      if (_isResonated) {
        final response = await _api.unresonateBottle(widget.bottleId);
        if (response.success) {
          setState(() {
            _isResonated = false;
            _resonateCount--;
          });
        }
      } else {
        final response = await _api.resonateBottle(widget.bottleId);
        if (response.success) {
          setState(() {
            _isResonated = true;
            _resonateCount++;
          });
        }
      }
    } catch (e) {
      Get.snackbar('错误', '操作失败，请稍后重试');
    }
  }

  Future<void> _handleFavorite() async {
    try {
      if (_isFavorited) {
        final response = await _api.unfavoriteBottle(widget.bottleId);
        if (response.success) {
          setState(() => _isFavorited = false);
        }
      } else {
        final response = await _api.favoriteBottle(widget.bottleId);
        if (response.success) {
          setState(() => _isFavorited = true);
        }
      }
    } catch (e) {
      Get.snackbar('错误', '操作失败，请稍后重试');
    }
  }

  Widget _buildInteractionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: _handleResonate,
          child: _buildInteractionButton(
            _isResonated ? Icons.favorite : Icons.favorite_border,
            _resonateCount.toString(),
            _isResonated ? Colors.red : Colors.grey[700],
          ),
        ),
        _buildInteractionButton(
            Icons.chat_bubble_outline, '207', Colors.grey[700]),
        _buildInteractionButton(Icons.send, '123', Colors.grey[700]),
        InkWell(
          onTap: _handleFavorite,
          child: _buildInteractionButton(
            _isFavorited ? Icons.bookmark : Icons.bookmark_border,
            '',
            _isFavorited ? Colors.blue : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildInteractionButton(IconData icon, String count, Color? color) {
    return Row(
      children: [
        Icon(icon, size: 24, color: color),
        if (count.isNotEmpty) ...[
          const SizedBox(width: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景渐变模糊效果
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple.withOpacity(0.1),
                  const Color.fromARGB(255, 253, 211, 86).withOpacity(0.3),
                  Colors.blue.withOpacity(0.5),
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ),
          // 主要内容
          Column(
            children: [
              // 图片区域
              Hero(
                tag: 'bottle_card_image_${widget.imageUrl}',
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(widget.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              // 内容区域
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 位置信息
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 正文内容
                      Text(
                        widget.content,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (widget.audioUrl != null &&
                          widget.audioUrl!.isNotEmpty)
                        AudioPlayerWidget(audioUrl: widget.audioUrl!),
                      // 互动按钮
                      _buildInteractionButtons(),
                    ],
                  ),
                ),
              ),

              // 评论输入框
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/avatar.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100]?.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Write comment here',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 5,
                            ),
                            suffixIcon: Icon(
                              Icons.send,
                              color: Colors.blue[400],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 返回按钮
          SafeArea(
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),

          // 用户信息卡片 - 放在最外层的Stack中
          Positioned(
            left: 20,
            right: 20,
            top: MediaQuery.of(context).size.height * 0.5 - 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // 用户头像
                      InkWell(
                        onTap: () {
                          if (widget.user?.id != null && widget.user!.id != 0) {
                            Get.toNamed(
                              '/profile/${widget.user!.id}', // 使用命名路由
                              arguments: {
                                'userId': widget.user!.id,
                                'nickname': widget.user!.nickname,
                                'avatar': widget.user!.avatar,
                              },
                            );
                          }
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                            image: DecorationImage(
                              image: NetworkImage(widget.user?.avatar ?? ''),
                              fit: BoxFit.cover,
                              onError: (_, __) =>
                                  const Icon(Icons.person), // 添加错误处理
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 用户名和时间
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.user?.nickname ?? '',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.verified,
                                size: 18,
                                color: Colors.blue[400],
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.time,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
