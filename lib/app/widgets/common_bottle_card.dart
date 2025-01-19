import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:fangkong_xinsheng/app/widgets/mood_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/square/views/bottle_card_detail.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/view_history.dart';

class CommonBottleCard extends StatelessWidget {
  final BottleModel bottle;

  const CommonBottleCard({
    super.key,
    required this.bottle,
  });

  @override
  Widget build(BuildContext context) {
    // 判断瓶子类型
    bool isImageBottle = bottle.imageUrl.isNotEmpty;
    bool isAudioBottle = bottle.audioUrl.isNotEmpty;

    // 定义渐变背景颜色
    List<Color> getGradientColors() {
      if (isAudioBottle) {
        return [
          const Color(0xFFFF8C61),
          const Color(0xFFFF6B6B),
        ];
      } else {
        return [
          const Color(0xFF4FACFE),
          const Color(0xFF00F2FE),
        ];
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.to(
          () => BottleCardDetail(
            id: bottle.id,
            imageUrl: bottle.imageUrl,
            title: bottle.title,
            content: bottle.content,
            createdAt: bottle.createdAt.toString(),
            audioUrl: bottle.audioUrl,
            user: bottle.user,
            mood: bottle.mood,
            resonates: bottle.resonates,
            favorites: bottle.favorites,
            isFavorited: bottle.isFavorited,
            isResonated: bottle.isFavorited,
            views: bottle.views,
            shares: bottle.shares,
          ),
          transition: Transition.cupertino,
        ),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 2 / 1,
              child: isImageBottle
                  ? Image.network(
                      bottle.imageUrl,
                      fit: BoxFit.cover,
                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
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
                          child: Icon(Icons.broken_image_rounded, color: Colors.grey[400], size: 40),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: getGradientColors()),
                      ),
                      child: Center(
                        child: Icon(isAudioBottle ? Icons.audiotrack_rounded : Icons.format_quote_rounded, size: 40, color: Colors.white.withOpacity(0.3)),
                      ),
                    ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              top: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
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
                        color: Colors.white,
                        size: 14),
                    const SizedBox(width: 4),
                    Text(
                      isImageBottle
                          ? '图片'
                          : isAudioBottle
                              ? '语音'
                              : '文字',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                        backgroundImage: NetworkImage(bottle.user.avatar),
                        backgroundColor: Colors.black26,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          bottle.user.nickname,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (bottle.mood.isNotEmpty) buildMoodChip(bottle.mood, size: 15),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bottle.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (bottle.content.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(bottle.content, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                  const SizedBox(height: 8),
                  _buildBottomStats(bottle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomStats(BottleModel bottle) {
    return Row(
      children: [
        Icon(
          Icons.remove_red_eye_outlined,
          size: 16,
          color: Colors.white.withOpacity(0.7),
        ),
        const SizedBox(width: 4),
        Text(
          '${bottle.views}',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 16),
        Icon(Icons.favorite_outline_outlined, size: 16, color: bottle.isResonated ? Colors.redAccent : Colors.white.withOpacity(0.7)),
        const SizedBox(width: 4),
        Text('${bottle.resonates}', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
        const SizedBox(width: 16),
        Icon(Icons.collections_bookmark_outlined, size: 16, color: bottle.isFavorited ? Colors.blueAccent : Colors.white.withOpacity(0.7)),
        const SizedBox(width: 4),
        Text('${bottle.favorites}', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
        const Spacer(),
        Text(
          _formatDate(DateTime.parse(bottle.createdAt)),
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
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
