import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/setting/controller.dart';

class CustomDrawer extends StatelessWidget {
  final SettingController settingController;

  const CustomDrawer({
    Key? key,
    required this.settingController,
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
                child: Column(
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
                              const CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    AssetImage('assets/images/avatar.jpg'),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tzuyu',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '@tzuyu',
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

                    // 设置选项列表
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        children: [
                          // 主题设置
                          _buildSettingItem(
                            icon: Icons.dark_mode,
                            title: 'dark_mode'.tr,
                            trailing: Switch(
                              value: settingController.isDarkMode,
                              onChanged: (_) => settingController.toggleTheme(),
                            ),
                          ),

                          // 语言设置
                          _buildSettingItem(
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
                            icon: Icons.notifications,
                            title: '通知设置',
                            onTap: () {},
                          ),
                          _buildSettingItem(
                            icon: Icons.security,
                            title: '隐私设置',
                            onTap: () {},
                          ),
                          _buildSettingItem(
                            icon: Icons.help,
                            title: '帮助与反馈',
                            onTap: () {},
                          ),
                          _buildSettingItem(
                            icon: Icons.logout,
                            title: '退出登录',
                            textColor: Colors.red,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.grey[600]),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
