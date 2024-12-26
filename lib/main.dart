import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_study/app/pages/bottle/view.dart';
import 'package:getx_study/app/pages/not_found.dart';
import 'package:getx_study/app/pages/setting/view.dart';
import 'package:getx_study/app/router/index.dart';
import 'package:getx_study/app/core/translations/translations.dart';
import 'package:getx_study/app/core/services/storage_service.dart';
import 'package:getx_study/app/core/services/app_service.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化服务
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => AppService().init());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Study',
      getPages: AppRoutes.getPages(),
      home: const MyHomePage(),
      unknownRoute: GetPage(name: "/notfound", page: () => const NotFound()),

      // 主题配置
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,

      // 国际化配置
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);
  int maxCount = 5;

  final List<Widget> _pages = [
    const BottlePage(),
    const Text('动画学习'),
    const Text('Page 3'),
    const SettingPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
        extendBody: true,
        bottomNavigationBar:
            _buildBottomNavigationBar(context, _controller, _pageController));
  }
}

Widget _buildBottomNavigationBar(BuildContext context,
    NotchBottomBarController controller, PageController pageController) {
  return AnimatedNotchBottomBar(
    notchBottomBarController: controller, // 控制器
    color: Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : const Color(0xFF1F1F1F), // 浅色主题用白色，深色主题用深灰色
    showLabel: true, //  是否显示文字
    textOverflow: TextOverflow.visible,
    shadowElevation: 5,
    kBottomRadius: 10.0,
    notchColor: Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFF5F5F5) // 浅色主题用浅灰色
        : const Color(0xFF2C2C2C), // 深色主��用稍亮的深灰色
    removeMargins: true,
    bottomBarWidth: MediaQuery.of(context).size.width,
    showShadow: true,
    durationInMilliSeconds: 300,
    itemLabelStyle: TextStyle(
      fontSize: 10,
      color: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFF666666)
          : const Color(0xFFE0E0E0),
    ),
    elevation: 4.0,
    bottomBarItems: [
      BottomBarItem(
        inActiveItem: Icon(
          Icons.home_filled,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[400] // 未激活时用浅灰色
              : Colors.grey[600], // 深色主题未激活时用深灰色
        ),
        activeItem: Icon(
          Icons.home_filled,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
        itemLabel: 'nav_bottle'.tr,
      ),
      BottomBarItem(
        inActiveItem: Icon(
          Icons.star,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[400]
              : Colors.grey[600],
        ),
        activeItem: Icon(
          Icons.star,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
        itemLabel: 'nav_square'.tr,
      ),
      BottomBarItem(
        inActiveItem: Icon(
          Icons.settings,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[400]
              : Colors.grey[600],
        ),
        activeItem: Icon(
          Icons.settings,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
        itemLabel: 'nav_time'.tr,
      ),
      BottomBarItem(
        inActiveItem: Icon(
          Icons.person,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[400]
              : Colors.grey[600],
        ),
        activeItem: Icon(
          Icons.person,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
        itemLabel: 'nav_mine'.tr,
      ),
    ],
    onTap: (index) {
      pageController.jumpToPage(index);
    },
    kIconSize: 24.0,
  );
}
