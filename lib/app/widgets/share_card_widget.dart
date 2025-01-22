import 'dart:ui';
import 'package:fangkong_xinsheng/app/widgets/cache_user_avatar.dart';
import 'package:fangkong_xinsheng/app/widgets/mood_chip.dart';
import 'package:flutter/material.dart';
import 'package:fangkong_xinsheng/app/utils/index.dart';
import 'package:get/get.dart';

class ShareCardWidget extends StatelessWidget {
  final String title;
  final String content;
  final String? imageUrl;
  final String? audioUrl;
  final String createdAt;
  final String? userAvatar;
  final String? userNickname;
  final String? mood;

  const ShareCardWidget({super.key, required this.title, required this.content, this.imageUrl, this.audioUrl, required this.createdAt, this.userAvatar, this.userNickname, this.mood});

  @override
  Widget build(BuildContext context) {
    bool isImageBottle = imageUrl?.isNotEmpty ?? false;
    bool isAudioBottle = audioUrl?.isNotEmpty ?? false;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, spreadRadius: 1)],
        image: isImageBottle ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken)) : null,
        gradient: !isImageBottle
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isAudioBottle
                    ? [
                        const Color(0xFFFF8C61),
                        const Color(0xFFFF6B6B),
                      ]
                    : [
                        const Color(0xFF4FACFE),
                        const Color(0xFF00F2FE),
                      ],
              )
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isImageBottle) Icon(isAudioBottle ? Icons.audiotrack_rounded : Icons.format_quote_rounded, size: 40, color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            buildMoodChip(mood, size: 16),
          ]),
          const SizedBox(height: 12),
          Text(content, style: TextStyle(fontSize: 14, letterSpacing: 1.3, color: Colors.white.withOpacity(0.9)), maxLines: 10, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CacheUserAvatar(avatarUrl: userAvatar!, size: 40),
              const SizedBox(width: 8),
              Text(userNickname ?? '匿名用户', style: const TextStyle(fontSize: 14, color: Colors.white)),
              const Spacer(),
              Text(formatTime(createdAt), style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6))),
            ],
          ),
        ],
      ),
    );
  }
}

class ShareBottomSheet extends StatelessWidget {
  final Widget shareCard;
  final VoidCallback onSaveLocal;
  final VoidCallback onShareWechat;
  final VoidCallback onShareTimeline;

  const ShareBottomSheet({
    super.key,
    required this.shareCard,
    required this.onSaveLocal,
    required this.onShareWechat,
    required this.onShareTimeline,
  });

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.grey[900], borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            shareCard,
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  icon: Icons.save_alt,
                  label: '保存本地',
                  onTap: onSaveLocal,
                ),
                _buildShareOption(
                  icon: Icons.wechat,
                  label: '微信好友',
                  onTap: onShareWechat,
                ),
                _buildShareOption(
                  icon: Icons.people_outline,
                  label: '朋友圈',
                  onTap: onShareTimeline,
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('取消'),
            ),
          ],
        ),
      ),
    );
  }
}
