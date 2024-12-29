import 'package:get/get.dart';
import 'package:getx_study/app/pages/home/index.dart';
import 'package:getx_study/app/pages/login/index.dart';
import 'package:getx_study/app/pages/profile/views/profile_page.dart';
import 'package:getx_study/app/pages/setting/view.dart';
import 'package:getx_study/app/pages/square/index.dart';
import 'package:getx_study/app/pages/time_post_office/controller.dart';
import 'package:getx_study/app/pages/time_post_office/view.dart';
import 'package:getx_study/main.dart';


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

  final Bindings? binding;

  const AppRoute({
    required this.name,
    required this.page,
    this.transition,
    this.middlewares,
    this.needAuth,
    this.binding,
  });

  GetPage toGetPage() {
    return GetPage(
      name: name,
      page: page,
      transition: transition ?? Transition.rightToLeft,
      middlewares: middlewares,
      binding: binding,
    );
  }
}

/// 路由管理
class AppRoutes {
  /// 定义路由名称常量
  static const home = '/';
  static const square = '/square';
  static const login = '/login';
  static const profile = '/profile';
  static const setting = '/setting';
  static const TIME_POST_OFFICE = '/time_post_office';
  
  /// 路由
  static final routes = <AppRoute>[
    AppRoute(
      name: login,
      page: () => const LoginPage(),
      transition: Transition.fadeIn,
    ),
    AppRoute(
      name: home,
      page: () => const MyHomePage(),
    ),
    AppRoute(
      name: square,
      page: () => const SquarePage(),
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
    AppRoute(
      name: '/profile',
      page: () => const ProfilePage(),
    ),
    AppRoute(
      name: TIME_POST_OFFICE,
      page: () => const TimePostOfficePage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TimePostOfficeController>(() => TimePostOfficeController());
      }),
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

  static const INITIAL = '/login'; // 设置初始路由为登录页
}
