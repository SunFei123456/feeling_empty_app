import 'package:fangkong_xinsheng/app/pages/views/create_topic_page.dart';
import 'package:fangkong_xinsheng/app/router/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/view/write_bottle_page.dart';
import 'package:fangkong_xinsheng/app/pages/time_post_office/views/write_letter_page.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart'
    show NotchBottomBarController;

class PublishPage extends StatelessWidget {
  const PublishPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        elevation: 0,
        title: Text(
          'publish'.tr,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "${'today_write_question'.tr} 🤔",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${'empty_voice_choice'.tr} 🎉',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: _buildTypeButton(
                      context: context,
                      icon: Icons.message,
                      label: 'bottle_title'.tr,
                      description: 'write_mood_flow'.tr,
                      color: const Color(0xFF6B4CE6),
                      onTap: () => Get.to(
                        () => const WriteBottlePage(),
                        transition: Transition.rightToLeft,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTypeButton(
                      context: context,
                      icon: Icons.mail,
                      label: 'time_letter'.tr,
                      description: 'write_to_future'.tr,
                      color: const Color(0xFF4ECDC4),
                      onTap: () => Get.to(
                        () => const WriteLetterPage(),
                        transition: Transition.rightToLeft,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildTypeButton(
                context: context,
                icon: Icons.tag,
                label: '创建话题',
                description: '发起一个新的话题讨论',
                color: const Color(0xFFFF6B6B),
                onTap: () => AppRoutes.to(AppRoutes.CREATE_TOPIC),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? color.withOpacity(0.15) : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? color.withOpacity(0.4) : color.withOpacity(0.3),
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? color.withOpacity(0.2) : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: isDark ? color.withOpacity(0.9) : color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? color.withOpacity(0.9) : color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'start_creating'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? color.withOpacity(0.9) : color,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: isDark ? color.withOpacity(0.9) : color,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
