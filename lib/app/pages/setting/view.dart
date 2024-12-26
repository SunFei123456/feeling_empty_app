import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './controller.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
      ),
      body: GetBuilder<SettingController>(
        init: SettingController(),
        builder: (controller) => ListView(
          children: [
            // 主题设置
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: Text('dark_mode'.tr),
              trailing: Switch(
                value: controller.isDarkMode,
                onChanged: (_) => controller.toggleTheme(),
              ),
            ),
            
            // 语言设置
            ListTile(
              leading: const Icon(Icons.language),
              title: Text('language'.tr),
              trailing: DropdownButton<Locale>(
                value: controller.currentLocale,
                items: controller.languages
                    .map((lang) => DropdownMenuItem(
                          value: lang['locale'] as Locale,
                          child: Text(lang['name'] as String),
                        ))
                    .toList(),
                onChanged: (locale) {
                  if (locale != null) {
                    controller.updateLocale(locale);
                  }
                },
              ),
            ),
            
            // 版本信息
            ListTile(
              leading: const Icon(Icons.info),
              title: Text('version'.tr),
              trailing: const Text('1.0.0'),
            ),
          ],
        ),
      ),
    );
  }
} 