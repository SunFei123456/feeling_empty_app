import 'dart:ui';
import 'dart:typed_data';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:fangkong_xinsheng/app/pages/profile/views/profile_page.dart';
import 'package:fangkong_xinsheng/app/pages/square/controller/square_controller.dart';
import 'package:fangkong_xinsheng/app/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/view_history.dart';
import 'package:fangkong_xinsheng/app/widgets/audio_player_widget.dart';

import 'package:fangkong_xinsheng/app/pages/views/api/user_bottles_api.dart';
import 'package:fangkong_xinsheng/app/widgets/share_card_widget.dart';
// 凡是进入到 瓶子的详情页,  走这个页面 BottleCardDetail
// ignore: must_be_immutable
class BottleCardDetail extends StatefulWidget {
  final int id;
  final String imageUrl;
  final String title;
  final String content;
  final String createdAt;
  final String? audioUrl;
  final UserInfo? user;
  int resonates;
  int favorites;
  final int shares;
  final int views;
  bool isResonated;
  bool isFavorited;

  BottleCardDetail({
    super.key,
    required this.id,
    this.imageUrl = '',
    this.title = '',
    this.content = '',
    this.user,
    this.createdAt = '',
    this.audioUrl = '',
    this.views = 0, // 浏览数量
    this.favorites = 0, // 收藏数量
    this.resonates = 0, // 共振数量
    this.shares = 0, // 分享数量
    this.isResonated = false,
    this.isFavorited = false,
  });

  @override
  State<BottleCardDetail> createState() => _BottleCardDetailState();
}

class _BottleCardDetailState extends State<BottleCardDetail> {
  final _api = BottleInteractionApiService();
  final _screenshotController = ScreenshotController();

  final squareController = Get.put(SquareController());
  @override
  void initState() {
    super.initState();
    // 同步瓶子状态
    final bottleStatus = squareController.getBottleStatus(widget.id);
    if (bottleStatus != null) {
      setState(() {
        widget.isResonated = bottleStatus.isResonated;
        widget.resonates = bottleStatus.resonates;
        widget.isFavorited = bottleStatus.isFavorited;
        widget.favorites = bottleStatus.favorites;
      });
    }
  }

  Future<void> _handleResonate() async {
    try {
      if (widget.isResonated) {
        // 改回原来的逻辑
        final response = await _api.unresonateBottle(widget.id);
        if (response.success) {
          setState(() {
            widget.resonates--;
            widget.isResonated = false;
          });
          squareController.updateBottleResonateStatus(
            widget.id,
            isResonated: false,
            resonates: widget.resonates,
          );
        }
      } else {
        final response = await _api.resonateBottle(widget.id);
        if (response.success) {
          setState(() {
            widget.resonates++;
            widget.isResonated = true;
          });
          squareController.updateBottleResonateStatus(
            widget.id,
            isResonated: true,
            resonates: widget.resonates,
          );
        }
      }
    } catch (e) {
      Get.snackbar('错误', '操作失败，请稍后重试');
    }
  }

  Future<void> _handleFavorite() async {
    try {
      if (widget.isFavorited) {
        final response = await _api.unfavoriteBottle(widget.id);
        if (response.success) {
          setState(() {
            widget.favorites--;
            widget.isFavorited = false;
          });
          squareController.updateBottleFavoriteStatus(
            widget.id,
            isFavorited: false,
            favorites: widget.favorites,
          );
        }
      } else {
        final response = await _api.favoriteBottle(widget.id);
        if (response.success) {
          setState(() {
            widget.favorites++;
            widget.isFavorited = true;
          });
          squareController.updateBottleFavoriteStatus(
            widget.id,
            isFavorited: true,
            favorites: widget.favorites,
          );
        }
      }
    } catch (e) {
      Get.snackbar('错误', '操作失败，请稍后重试');
    }
  }

  Future<void> _saveToLocal() async {
    try {
      // 截取分享卡片
      final Uint8List? imageBytes = await _screenshotController.captureFromWidget(
        MediaQuery(
          data: MediaQueryData.fromView(View.of(context)),
          child: ShareCardWidget(
            title: widget.title,
            content: widget.content,
            imageUrl: widget.imageUrl,
            audioUrl: widget.audioUrl,
            createdAt: widget.createdAt,
            userAvatar: widget.user?.avatar,
            userNickname: widget.user?.nickname,
          ),
        ),
        delay: const Duration(milliseconds: 10),
        pixelRatio: 3.0,
        context: context,
      );

      if (imageBytes != null) {
        // 保存到相册
        final result = await ImageGallerySaver.saveImage(
          imageBytes,
          quality: 100,
          name: "bottle_${DateTime.now().millisecondsSinceEpoch}",
        );

        if (result['isSuccess']) {
          Get.back();
          Get.snackbar('成功', '图片已保存到相册');
        } else {
          Get.snackbar('错误', '保存失败，请重试');
        }
      }
    } catch (e) {
      Get.snackbar('错误', '保存失败：$e');
    }
  }

  Widget _buildInteractionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: _handleResonate,
          child: _buildInteractionButton(
            widget.isResonated ? Icons.favorite : Icons.favorite_border,
            widget.resonates,
            widget.isResonated ? Colors.red : Colors.grey[700],
          ),
        ),
        InkWell(
          onTap: _handleFavorite,
          child: _buildInteractionButton(
            widget.isFavorited ? Icons.bookmark : Icons.bookmark_border,
            widget.favorites,
            widget.isFavorited ? Colors.blue : Colors.grey[700],
          ),
        ),
        InkWell(
          onTap: () {},
          child: _buildInteractionButton(
              Icons.remove_red_eye_outlined, widget.views, Colors.grey[700]),
        ),
        InkWell(
          onTap: _showShareOptions,
          child: _buildInteractionButton(
              Icons.share, widget.shares, Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildInteractionButton(IconData icon, int count, Color? color) {
    return Row(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ShareBottomSheet(
        shareCard: ShareCardWidget(
          title: widget.title,
          content: widget.content,
          imageUrl: widget.imageUrl,
          audioUrl: widget.audioUrl,
          createdAt: widget.createdAt,
          userAvatar: widget.user?.avatar,
          userNickname: widget.user?.nickname,
        ),
        onSaveLocal: _saveToLocal,
        onShareWechat: () {
          // TODO: 实现微信分享
          Get.back();
        },
        onShareTimeline: () {
          // TODO: 实现朋友圈分享
          Get.back();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 判断瓶子类型
    bool isImageBottle = widget.imageUrl.isNotEmpty;
    bool isAudioBottle = widget.audioUrl != null && widget.audioUrl!.isNotEmpty;
    bool isTextBottle = !isImageBottle && !isAudioBottle;

    // 定义渐变背景颜色
    List<Color> getGradientColors() {
      if (isAudioBottle) {
        return [
          const Color(0xFFFF8C61), // 珊瑚色
          const Color(0xFFFF6B6B), // 粉红色
        ];
      } else {
        return [
          const Color(0xFF4FACFE), // 天蓝色
          const Color(0xFF00F2FE), // 青色
        ];
      }
    }

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
              // 图片/渐变背景区域
              Hero(
                tag: 'bottle_card_image_${widget.imageUrl}',
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: isImageBottle
                      ? Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[100],
                            child: Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                color: Colors.grey[400],
                                size: 40,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: getGradientColors(),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              isAudioBottle
                                  ? Icons.audiotrack_rounded
                                  : Icons.format_quote_rounded,
                              size: 80,
                              color: Colors.white.withOpacity(0.3),
                            ),
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
                      // 类型标识
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isImageBottle
                                  ? Icons.image
                                  : isAudioBottle
                                      ? Icons.audiotrack
                                      : Icons.text_fields,
                              color: Colors.black54,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isImageBottle
                                  ? '图片'
                                  : isAudioBottle
                                      ? '语音'
                                      : '文字',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 标题
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 发布时间
                      Row(
                        children: [
                          Icon(Icons.timeline,
                              size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            formatTime(widget.createdAt),
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.7)),
                          ),
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
                            Get.to(
                              () => ProfilePage(userId: widget.user!.id),
                              transition: Transition.fadeIn,
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
                      // 用户名和认证标识
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
