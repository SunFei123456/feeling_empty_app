import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 确保按正确顺序初始化所有服务
  await dotenv.load(fileName: ".env");
  
  // 先初始化存储服务
  await Get.putAsync(() => StorageService().init());
  
  // 然后初始化 token 服务
  await Get.putAsync(() => TokenService().init());
  
  // 最后初始化其他服务
  final appService = await Get.putAsync(() => AppService().init());
  Get.put(SettingController());

  // 初始化 WebView
  late final WebViewPlatform platform;
  if (WebViewPlatform.instance == null) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      platform = WebKitWebViewPlatform();
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      platform = AndroidWebViewPlatform();
    }
    WebViewPlatform.instance = platform;
  }

  runApp(MyApp(
    initialLocale: appService.currentLocale,
    initialTheme: appService.currentThemeMode,
  ));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  final ThemeMode initialTheme;

  const MyApp({
    super.key,
    required this.initialLocale,
    required this.initialTheme,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '放空心声',
      getPages: AppRoutes.getPages(),
      unknownRoute: GetPage(name: "/notfound", page: () => const NotFound()),

      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: initialTheme,

      // 国际化配置
      translations: AppTranslations(),
      locale: initialLocale,
      fallbackLocale: const Locale('zh', 'CN'),
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
    const ProfilePage(),
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
            itemLabel: 'home'.tr,
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
            itemLabel: 'nav_publish'.tr,
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
