import 'package:fangkong_xinsheng/app/pages/profile/controller/profile_controller.dart';
import 'package:fangkong_xinsheng/app/router/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/setting/controller.dart';

class CustomDrawer extends StatelessWidget {
  final SettingController settingController;
  final ProfileController profileController;

  const CustomDrawer({
    Key? key,
    required this.settingController,
    required this.profileController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // 半透明背景，点击时关闭抽屉
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),
          // 抽屉内容
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.primaryDelta! > 0) {
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(-5, 0),
                    ),
                  ],
                ),
                child: Obx(() {
                  final user = profileController.user.value;
                  return Column(
                    children: [
                      // 顶部用户信息区域
                      Container(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 20,
                          bottom: 20,
                          left: 20,
                          right: 20,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.withOpacity(0.5),
                              Colors.purple.withOpacity(0.4),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(user?.avatar ?? ''),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user?.nickname ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '@ ${user?.nickname ?? ''}',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.white),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // 用户相关选项
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          children: [
                            _buildSettingItem(
                              context: context,
                              icon: Icons.edit,
                              title: '修改资料',
                              onTap: () => AppRoutes.to(AppRoutes.EDIT_PROFILE),
                            ),
                            _buildSettingItem(
                              context: context,
                              icon: Icons.history,
                              title: '浏览历史',
                              onTap: () => AppRoutes.to(AppRoutes.VIEW_HISTORY),
                            ),
                            _buildSettingItem(
                              context: context,
                              icon: Icons.bookmark,
                              title: '我的收藏',
                              onTap: () =>
                                  AppRoutes.to(AppRoutes.FAVORITED_BOTTLE),
                            ),
                            _buildSettingItem(
                              context: context,
                              icon: Icons.favorite,
                              title: '我的共鸣',
                              onTap: () =>
                                  AppRoutes.to(AppRoutes.RESONATED_BOTTLE),
                            ),

                            const Divider(height: 32), // 添加分隔线

                            // 原有的设置选项
                            _buildSettingItem(
                              context: context,
                              icon: Icons.dark_mode,
                              title: 'dark_mode'.tr,
                              trailing: Switch(
                                value: settingController.isDarkMode,
                                onChanged: (_) =>
                                    settingController.toggleTheme(),
                              ),
                            ),

                            // 语言设置
                            _buildSettingItem(
                              context: context,
                              icon: Icons.language,
                              title: 'language'.tr,
                              trailing: DropdownButton<Locale>(
                                value: settingController.currentLocale,
                                underline: const SizedBox(),
                                items: settingController.languages
                                    .map((lang) => DropdownMenuItem(
                                          value: lang['locale'] as Locale,
                                          child: Text(lang['name'] as String),
                                        ))
                                    .toList(),
                                onChanged: (locale) {
                                  if (locale != null) {
                                    settingController.updateLocale(locale);
                                  }
                                },
                              ),
                            ),

                            // 版本信息
                            _buildSettingItem(
                              context: context,
                              icon: Icons.info,
                              title: 'version'.tr,
                              trailing: const Text(
                                '1.0.0',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),

                            const Divider(),

                            // 其他选项
                            _buildSettingItem(
                              context: context,
                              icon: Icons.notifications,
                              title: '通知设置',
                              onTap: () {},
                            ),
                            _buildSettingItem(
                              context: context,
                              icon: Icons.security,
                              title: '隐私设置',
                              onTap: () {},
                            ),
                            _buildSettingItem(
                              context: context,
                              icon: Icons.help,
                              title: '帮助与反馈',
                              onTap: () {},
                            ),
                            _buildSettingItem(
                              context: context,
                              icon: Icons.logout,
                              title: '退出登录',
                              textColor: Colors.red,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? Theme.of(context).primaryColor.withOpacity(0.7),
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ??
          (onTap != null
              ? Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Colors.grey[400],
                )
              : null),
      onTap: onTap,
      dense: true, // 使列表项更紧凑
      visualDensity: VisualDensity.compact, // 减小垂直间距
    );
  }
}
