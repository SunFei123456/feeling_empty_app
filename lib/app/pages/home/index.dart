import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import '../bottle/view.dart';
import '../setting/view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller = NotchBottomBarController(index: 0);

  final List<Widget> _pages = [
    const BottlePage(),
    const Center(child: Text('广场')),
    const Center(child: Text('时光机')),
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
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: Colors.white,
        showLabel: true,
        notchColor: const Color(0xFFFFFFFF),
        removeMargins: true,
        bottomBarWidth: MediaQuery.of(context).size.width,
        durationInMilliSeconds: 300,
        kBottomRadius: 28.0,
        kIconSize: 24.0,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(
              Icons.home_outlined,
              color: Colors.grey[400],
            ),
            activeItem: const Icon(
              Icons.home,
              color: Colors.blue,
            ),
            itemLabel: 'nav_bottle'.tr,
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.grid_view_outlined,
              color: Colors.grey[400],
            ),
            activeItem: const Icon(
              Icons.grid_view,
              color: Colors.blue,
            ),
            itemLabel: 'nav_square'.tr,
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.access_time_outlined,
              color: Colors.grey[400],
            ),
            activeItem: const Icon(
              Icons.access_time,
              color: Colors.blue,
            ),
            itemLabel: 'nav_time'.tr,
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.person_outline,
              color: Colors.grey[400],
            ),
            activeItem: const Icon(
              Icons.person,
              color: Colors.blue,
            ),
            itemLabel: 'nav_mine'.tr,
          ),
        ],
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}
