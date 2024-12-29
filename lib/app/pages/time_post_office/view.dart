import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/time_post_office/views/write_letter_page.dart';
import './controller.dart';
import './widgets/post_list.dart';

class TimePostOfficePage extends StatefulWidget {
  const TimePostOfficePage({Key? key}) : super(key: key);

  @override
  State<TimePostOfficePage> createState() => _TimePostOfficePageState();
}

class _TimePostOfficePageState extends State<TimePostOfficePage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final controller = Get.find<TimePostOfficeController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    if (mounted) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'nav_time'.tr,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => Get.to(() => const WriteLetterPage()),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            tabAlignment: TabAlignment.start,
            controller: _tabController,
            isScrollable: true,
            labelColor: isDark ? Colors.white : Colors.black,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelColor: isDark ? Colors.grey[600] : Colors.grey,
            indicatorColor: isDark ? Colors.white : Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: Colors.transparent,
            padding: EdgeInsets.zero,
            indicatorPadding: const EdgeInsets.only(bottom: 4, top: 2),
            indicatorWeight: 1,
            tabs: const [
              Tab(text: '全部'),
              Tab(text: '文字'),
              Tab(text: '图片'),
              Tab(text: '视频'),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: List.generate(4, (index) => const PostList()),
        ),
      ),
    );
  }
}
