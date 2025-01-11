import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/view.dart';
import 'package:fangkong_xinsheng/app/pages/views/not_found.dart';
import 'package:fangkong_xinsheng/app/pages/profile/views/profile_page.dart';
import 'package:fangkong_xinsheng/app/pages/setting/controller.dart';
import 'package:fangkong_xinsheng/app/pages/square/index.dart';
import 'package:fangkong_xinsheng/app/router/index.dart';
import 'package:fangkong_xinsheng/app/core/translations/translations.dart';
import 'package:fangkong_xinsheng/app/core/services/storage_service.dart';
import 'package:fangkong_xinsheng/app/core/services/app_service.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:fangkong_xinsheng/app/pages/time_post_office/view.dart';
import 'package:fangkong_xinsheng/app/pages/time_post_office/controller.dart';
import 'package:fangkong_xinsheng/app/pages/publish/view.dart';
import 'package:fangkong_xinsheng/app/core/services/token_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 确保在获取初始路由前已初始化存储
  await Get.putAsync(() => TokenService().init());

  // 初始化服务
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => AppService().init());
  Get.put(SettingController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '放空心声',
      getPages: AppRoutes.getPages(),
      unknownRoute: GetPage(name: "/notfound", page: () => const NotFound()),

      darkTheme: ThemeData.dark(), // 保留深色主题配置
      themeMode: ThemeMode.light, // 强制使用亮色主题

      // 国际化配置
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppRoutes.INITIAL,
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
  int maxCount = 4;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    Get.put(TimePostOfficeController());

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ));
  }

  final List<Widget> _pages = [
    const BottlePage(),
    const SquarePage(),
    const PublishPage(),
    const TimePostOfficePage(),
    ProfilePage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF1F1F1F),
        showLabel: true,
        textOverflow: TextOverflow.visible,
        shadowElevation: 5,
        kBottomRadius: 10.0,
        notchColor: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFF5F5F5)
            : const Color(0xFF2C2C2C),
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
                  ? Colors.grey[400]
                  : Colors.grey[600],
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
              Icons.add_circle_outline,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[400]
                  : Colors.grey[600],
            ),
            activeItem: Icon(
              Icons.add_circle,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
            itemLabel: '发布'.tr,
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
          _pageController.jumpToPage(index);
        },
        kIconSize: 24.0,
      ),
    );
  }
}
