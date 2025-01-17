import 'package:fangkong_xinsheng/app/core/services/token_service.dart';
import 'package:fangkong_xinsheng/app/pages/profile/controller/profile_controller.dart';
import 'package:fangkong_xinsheng/app/pages/profile/model/user.dart';
import 'package:fangkong_xinsheng/app/router/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/setting/controller.dart';

class CustomDrawer extends StatelessWidget {
  final SettingController settingController;
  final ProfileController profileController;

  const CustomDrawer({
    super.key,
    required this.settingController,
    required this.profileController,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // 半透明背景
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black26,
            ),
          ),
          // 抽屉内容
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(20)),
              ),
              child: Obx(() {
                final user = profileController.user.value;
                return Column(
                  children: [
                    // 用户信息区域
                    _buildUserHeader(context, user, isDark),

                    // 菜单列表
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        children: [
                          _buildMenuSection(
                            context,
                            isDark,
                            items: [
                              MenuItem(
                                  icon: Icons.edit,
                                  title: 'edit_profile'.tr,
                                  onTap: () =>
                                      AppRoutes.to(AppRoutes.EDIT_PROFILE)),
                              MenuItem(
                                  icon: Icons.history,
                                  title: 'browsing_history'.tr,
                                  onTap: () =>
                                      AppRoutes.to(AppRoutes.VIEW_HISTORY)),
                              MenuItem(
                                  icon: Icons.bookmark,
                                  title: 'my_favorites'.tr,
                                  onTap: () =>
                                      AppRoutes.to(AppRoutes.FAVORITED_BOTTLE)),
                              MenuItem(
                                  icon: Icons.favorite,
                                  title: 'my_resonance'.tr,
                                  onTap: () =>
                                      AppRoutes.to(AppRoutes.RESONATED_BOTTLE)),
                            ],
                          ),
                          _buildDivider(isDark),
                          _buildMenuSection(
                            context,
                            isDark,
                            items: [
                              MenuItem(
                                icon: Icons.dark_mode,
                                title: 'dark_mode'.tr,
                                trailing: Switch(
                                  activeColor: Colors.blue,
                                  value: settingController.isDarkMode,
                                  onChanged: (_) =>
                                      settingController.toggleTheme(),
                                ),
                              ),
                              MenuItem(
                                icon: Icons.language,
                                title: 'language'.tr,
                                trailing:
                                    _buildLanguageDropdown(context, isDark),
                              ),
                            ],
                          ),
                          _buildDivider(isDark),
                          _buildMenuSection(
                            context,
                            isDark,
                            items: [
                              MenuItem(
                                icon: Icons.logout,
                                title: 'log_out'.tr,
                                textColor: Colors.red,
                                onTap: () async {
                                  await Get.delete<ProfileController>(
                                      force: true);
                                  await TokenService().clearAuth();
                                  AppRoutes.offAll(AppRoutes.login);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, UserModel? user, bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? Colors.black12 : Colors.blue.withOpacity(0.1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(user?.avatar ?? ''),
            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.nickname ?? '',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  '@${user?.nickname ?? ''}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, bool isDark,
      {required List<MenuItem> items}) {
    return Column(
      children:
          items.map((item) => _buildMenuItem(context, item, isDark)).toList(),
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem item, bool isDark) {
    return ListTile(
      leading: Icon(
        item.icon,
        color: item.textColor ?? (isDark ? Colors.white70 : Colors.black54),
        size: 22,
      ),
      title: Text(
        item.title,
        style: TextStyle(
          color: item.textColor ?? (isDark ? Colors.white : Colors.black87),
          fontSize: 15,
        ),
      ),
      trailing: item.trailing,
      onTap: item.onTap,
      dense: true,
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(color: isDark ? Colors.white12 : Colors.black12);
  }

  Widget _buildLanguageDropdown(BuildContext context, bool isDark) {
    return Theme(
      data: Theme.of(context).copyWith(
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
      child: DropdownButton<Locale>(
        value: settingController.currentLocale,
        underline: const SizedBox(),
        dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        items: settingController.languages
            .map((lang) => DropdownMenuItem(
                  value: lang['locale'] as Locale,
                  child: Text(
                    lang['name'] as String,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ))
            .toList(),
        onChanged: (Locale? newValue) {
          if (newValue != null) {
            settingController.updateLocale(newValue);
          }
        },
      ),
    );
  }
}

class MenuItem {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? textColor;

  MenuItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.textColor,
  });
}
