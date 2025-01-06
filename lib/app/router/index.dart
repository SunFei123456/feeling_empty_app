import 'package:fangkong_xinsheng/app/pages/bottle/controller/bottle_controller.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/view/hot_bottles_page.dart';
import 'package:fangkong_xinsheng/app/pages/views/favorite_page.dart';
import 'package:fangkong_xinsheng/app/pages/views/ocean_square_page.dart';
import 'package:fangkong_xinsheng/app/pages/views/resonated_page.dart';
import 'package:fangkong_xinsheng/app/pages/views/view_history_page.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/view.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/view/write_bottle_page.dart';
import 'package:fangkong_xinsheng/app/pages/home/index.dart';
import 'package:fangkong_xinsheng/app/pages/login/index.dart';
import 'package:fangkong_xinsheng/app/pages/profile/views/profile_page.dart';
import 'package:fangkong_xinsheng/app/pages/publish/view.dart';
import 'package:fangkong_xinsheng/app/pages/setting/view.dart';
import 'package:fangkong_xinsheng/app/pages/square/index.dart';
import 'package:fangkong_xinsheng/app/pages/time_post_office/controller.dart';
import 'package:fangkong_xinsheng/app/pages/time_post_office/view.dart';
import 'package:fangkong_xinsheng/app/pages/time_post_office/views/write_letter_page.dart';
import 'package:fangkong_xinsheng/app/pages/views/topic_detail_page.dart';
import 'package:fangkong_xinsheng/app/pages/profile/views/edit_profile_page.dart';
import 'package:fangkong_xinsheng/main.dart';

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
  static const BOTTLE = '/bottle';
  static const BOTTLE_DETAIL = '/bottle_detail';
  static const TOPIC_DETAIL = '/topic_detail';
  static const WRITE_BOTTLE = '/write_bottle';
  static const WRITE_LETTER = '/write_letter';
  static const HOT_BOTTLE = '/hot_bottle';
  static const TOPIC = '/topic';
  static const PUBLISH = '/publish';
  static const EDIT_PROFILE = '/edit-profile';
  static const VIEW_HISTORY = '/view_history';
  static const RESONATED_BOTTLE = '/resonated_bottle';
  static const FAVORITED_BOTTLE = '/favorited_bottle';
  static const OCEANSQUARE = '/ocean_square';

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
    // 广场
    AppRoute(
      name: square,
      page: () => const SquarePage(),
    ),
    // 漂流瓶
    AppRoute(
      name: BOTTLE,
      page: () => const BottlePage(),
    ),
    // 时光邮局
    AppRoute(
      name: TIME_POST_OFFICE,
      page: () => const TimePostOfficePage(),
    ),
    // 发布
    AppRoute(
      name: PUBLISH,
      page: () => const PublishPage(),
    ),
    // 我的
    AppRoute(
      name: '/profile',
      page: () => ProfilePage(),
    ),

    // ----------------------------------- 二级页面-----------------------------------
    // 写漂流瓶
    AppRoute(
      name: WRITE_BOTTLE,
      page: () => const WriteBottlePage(),
    ),
    // 写时光信件
    AppRoute(
      name: WRITE_LETTER,
      page: () => const WriteLetterPage(),
    ),
    // 设置
    AppRoute(
      name: setting,
      page: () => const SettingPage(),
    ),

    AppRoute(
      name: TIME_POST_OFFICE,
      page: () => const TimePostOfficePage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TimePostOfficeController>(() => TimePostOfficeController());
      }),
    ),

    // 用户信息编辑
    AppRoute(
      name: EDIT_PROFILE,
      page: () => const EditProfilePage(),
    ),

    // 历史记录页面
    AppRoute(
      name: VIEW_HISTORY,
      page: () =>  ViewHistoryPage(),
    ),

    // 热门漂流瓶
    AppRoute(
      name: HOT_BOTTLE,
      page: () => const HotBottlesPage(),
      binding: BindingsBuilder(() {
        Get.put(BottleController());
      }),
    ),

    // 收藏的漂流瓶列表页面
    AppRoute(
      name: FAVORITED_BOTTLE,
      page: () =>  FavoritePage(),
    ),

    // 共振 的漂流瓶列表页面
    AppRoute(
      name: RESONATED_BOTTLE,
      page: () =>  ResonatedPage(),
    ),
    // 海域广场页面
    AppRoute(
      name: OCEANSQUARE,
      page: () =>  OceanSquarePage(),
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
