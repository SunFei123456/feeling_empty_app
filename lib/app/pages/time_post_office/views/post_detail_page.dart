import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import './letter_content_page.dart';

class PostDetailPage extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostDetailPage({Key? key, required this.post}) : super(key: key);

  bool _canOpenLetter() {
    // 这里添加时间判断逻辑
    final unlockTime = DateTime.parse(post['unlockTime'].toString().replaceAll('.', '-'));
    final now = DateTime.now();
    return now.isAfter(unlockTime);
  }

  void _showUnlockAnimation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(
                'assets/animations/unlock.json',  // 需要添加开锁动画文件
                repeat: false,
                onLoaded: (composition) {
                  Future.delayed(composition.duration, () {
                    Get.back(); // 关闭动画对话框
                    Get.to(() => LetterContentPage(post: post)); // 跳转到信件内容页
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool canOpen = _canOpenLetter();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: post['imageUrl'] != null ? 300 : 0,
            pinned: true,
            stretch: true,
            backgroundColor: isDark ? const Color(0xFF242424) : Colors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: post['imageUrl'] != null
                ? FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          post['imageUrl'],
                          fit: BoxFit.cover,
                        ),
                        // 渐变遮罩
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 类型和分类标签
                  Row(
                    children: [
                      _buildTag(post['type'] ?? '', Colors.blue, isDark),
                      const SizedBox(width: 8),
                      _buildTag(post['category'] ?? '', Colors.orange, isDark),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // 标题
                  Text(
                    post['title'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 作者和时间信息
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: isDark ? Colors.blue[900] : Colors.blue[100],
                        child: Text(
                          post['author'][0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 18,
                            color: isDark ? Colors.blue[100] : Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['author'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            '写给未来的自己',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // 分隔线
                  Divider(color: isDark ? Colors.grey[800] : Colors.grey[200], thickness: 1),
                  const SizedBox(height: 24),
                  // 内容
                  Text(
                    post['content'],
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: isDark ? Colors.grey[300] : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 信件区域
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.blue[900]!.withOpacity(0.2) : Colors.blue[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.blue[800]! : Colors.blue[100]!,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.mail_outline,
                              color: isDark ? Colors.blue[200] : Colors.blue[700],
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '未来信件',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark ? Colors.blue[200] : Colors.blue[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (canOpen)
                              TextButton.icon(
                                onPressed: () => _showUnlockAnimation(context),
                                icon: const Icon(Icons.lock_open),
                                label: const Text('打开信件'),
                                style: TextButton.styleFrom(
                                  backgroundColor: isDark ? Colors.blue[700] : Colors.blue[700],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          canOpen ? '信件已经可以打开了！' : '这封信将在以下时间开启：',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.blue[900]!.withOpacity(0.3) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                canOpen ? Icons.check_circle : Icons.calendar_today,
                                size: 16,
                                color: canOpen
                                    ? (isDark ? Colors.green[200] : Colors.green)
                                    : (isDark ? Colors.blue[200] : Colors.blue[700]),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                post['unlockTime'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: canOpen
                                      ? (isDark ? Colors.green[200] : Colors.green)
                                      : (isDark ? Colors.blue[200] : Colors.blue[700]),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!canOpen) ...[
                          const SizedBox(height: 12),
                          Text(
                            '信件内容将在指定时间后显示',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.grey[500] : Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, MaterialColor color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? color[900]!.withOpacity(0.2) : color[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDark ? color[200] : color[700],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
} 