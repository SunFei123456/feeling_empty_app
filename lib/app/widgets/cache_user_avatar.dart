import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CacheUserAvatar extends StatelessWidget {
  final String avatarUrl; // 用户头像 URL
  final double size; // 头像大小

  const CacheUserAvatar({super.key, required this.avatarUrl, this.size = 80.0});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: size,
      height: size,
      imageUrl: avatarUrl.isNotEmpty ? avatarUrl : 'assets/images/avatar.jpg',
      placeholder: (context, url) => const Icon(Icons.person), // 占位符
      errorWidget: (context, url, error) => const Icon(Icons.person), // 错误时显示的图标
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.purple[200]!, width: 3), image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
      ),
    );
  }
}

// 使用示例
// UserAvatar(avatarUrl: user.avatar, size: 80);