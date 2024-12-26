import 'package:get/get.dart';
import 'package:getx_study/app/pages/home/index.dart';
import 'package:getx_study/app/pages/setting/view.dart';

/// 路由管理类
class AppRoute {
  /// 路由名称
  final String name;
  
  /// 页面构建器
  final GetPageBuilder page;
  
  /// 转场动画
  final Transition? transition;
  
  /// 中间件
  final List<GetMiddleware>? middlewares;
  
  /// 是否需要认证
  final bool? needAuth;

  const AppRoute({
    required this.name,
    required this.page,
    this.transition,
    this.middlewares,
    this.needAuth,
  });

  GetPage toGetPage() {
    return GetPage(
      name: name,
      page: page,
      transition: transition ?? Transition.rightToLeft,
      middlewares: middlewares,
    );
  }
}

/// 路由管理
class AppRoutes {
  /// 定义路由名称常量
  static const home = '/';
  static const login = '/login';
  static const profile = '/profile';
  static const setting = '/setting';
  
  /// 路由表
  static final routes = <AppRoute>[
    AppRoute(
      name: home,
      page: () => const HomePage(),
    ),
    // AppRoute(
    //   name: login,
    //   page: () => const LoginPage(),
    //   transition: Transition.fadeIn,
    // ),
    // AppRoute(
    //   name: profile,
    //   page: () => const ProfilePage(),
    //   needAuth: true,
    // ),
    AppRoute(
      name: setting,
      page: () => const SettingPage(),
    ),
  ];

  /// 获取所有GetPage路由
  static List<GetPage> getPages() {
    return routes.map((route) => route.toGetPage()).toList();
  }

  /// 导航到指定页面
  static Future<T?>? to<T>(String name, {dynamic arguments}) {
    return Get.toNamed<T>(name, arguments: arguments);
  }

  /// 替换当前页面
  static Future<T?>? off<T>(String name, {dynamic arguments}) {
    return Get.offNamed<T>(name, arguments: arguments);
  }

  /// 清空所有页面并导航
  static Future<T?>? offAll<T>(String name, {dynamic arguments}) {
    return Get.offAllNamed<T>(name, arguments: arguments);
  }

  /// 返回上一页
  static void back<T>({T? result}) {
    Get.back<T>(result: result);
  }
}
