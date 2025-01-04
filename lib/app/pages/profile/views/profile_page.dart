import 'dart:ui';
import 'dart:io';
import 'package:fangkong_xinsheng/app/pages/square/views/bottle_card_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fangkong_xinsheng/app/pages/setting/controller.dart';
import 'package:fangkong_xinsheng/app/widgets/custom_drawer.dart';
import 'package:fangkong_xinsheng/app/pages/profile/controller/profile_controller.dart';
import 'package:fangkong_xinsheng/app/router/index.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final SettingController _settingController;
  late final ProfileController _profileController;

  // 示例图片数据
  final List<String> _publicImages = [
    'assets/images/avatar.jpg',
    'assets/images/avatar.jpg',
    'assets/images/avatar.jpg',
    'assets/images/avatar.jpg',
  ];

  final List<String> _privateImages = [
    'assets/images/avatar.jpg',
    'assets/images/avatar.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _settingController = Get.find<SettingController>();
    _profileController = Get.put(ProfileController());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景渐变模糊效果
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.withOpacity(0.5),
                  Colors.pink.withOpacity(0.1),
                  Colors.white.withOpacity(0.2),
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ),

          // 主要内容
          SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // 顶部栏
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => Get.back(),
                              ),
                              Obx(() => Text(
                                '@${_profileController.user.value?.nickname ?? ""}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.more_horiz),
                                onPressed: () {
                                  showGeneralDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierLabel: '',
                                    barrierColor: Colors.black54,
                                    transitionDuration: const Duration(milliseconds: 300),
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1, 0),
                                          end: Offset.zero,
                                        ).animate(CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeInOut,
                                        )),
                                        child: CustomDrawer(
                                          settingController: _settingController,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        // 个人信息卡片
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(200),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Obx(() {
                            final user = _profileController.user.value;
                            final isLoading = _profileController.isLoading.value;

                            if (isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return Stack(
                              children: [
                                Column(
                                  children: [
                                    // 头像
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: user?.avatar != null && user!.avatar.isNotEmpty
                                              ? NetworkImage(user.avatar)
                                              : const AssetImage('assets/images/avatar.jpg') as ImageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // 用户名和认证标记
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          user?.nickname ?? '',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.verified,
                                          size: 20,
                                          color: Colors.blue[400],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),

                                    // 描述
                                    const Text(
                                      'Twice K-Pop Idol Group Member',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    // 统计数据
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildStat('233', 'Posts'),
                                        _buildStatDivider(),
                                        _buildStat('89 M', 'Followers'),
                                        _buildStatDivider(),
                                        _buildStat('12', 'Following'),
                                      ],
                                    ),
                                    const SizedBox(height: 20),

                                    // Follow 按钮
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text('Follow'),
                                      ),
                                    ),
                                  ],
                                ),
                                // 编辑按钮
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => AppRoutes.to(AppRoutes.EDIT_PROFILE),
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black.withOpacity(0.7),
                        padding: const EdgeInsets.all(3),
                        tabs: [
                          Tab(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Center(child: Text('公开')),
                            ),
                          ),
                          Tab(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Center(child: Text('私密')),
                            ),
                          ),
                        ],
                        dividerColor: Colors.transparent,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  // 公开照片瀑布流
                  RefreshIndicator(
                    onRefresh: _profileController.refreshBottles,
                    child: MasonryGridView.count(
                      padding: const EdgeInsets.all(16),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      itemCount: _profileController.publicBottles.length,
                      itemBuilder: (context, index) {
                        final bottle = _profileController.publicBottles[index];
                        // 如果到达列表底部，加载更多
                        if (index == _profileController.publicBottles.length - 1) {
                          _profileController.loadMoreBottles();
                        }
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => BottleCardDetail(
                                imageUrl: bottle.imageUrl.isNotEmpty 
                                    ? bottle.imageUrl 
                                    : 'https://picsum.photos/500/800',
                                title: bottle.title,
                                content: bottle.content,
                                time: bottle.createdAt,
                                location: '查看次数: ${bottle.views}',
                                audioUrl: bottle.audioUrl,
                              ),
                              transition: Transition.fadeIn,
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (bottle.imageUrl.isNotEmpty)
                                    AspectRatio(
                                      aspectRatio: 1,
                                      child: Image.network(
                                        bottle.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bottle.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          bottle.content,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                            height: 1.2,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.remove_red_eye,
                                                  size: 12,
                                                  color: Colors.grey[400],
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${bottle.views}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              bottle.createdAt.substring(0, 10),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // 私有照片瀑布流
                  MasonryGridView.count(
                    padding: const EdgeInsets.all(16),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    itemCount: _privateImages.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: index.isEven ? 200 : 240,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(_privateImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey[300],
    );
  }

  void _showImagePickerBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('拍照'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('从相册选择'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 90,
      );

      if (image != null) {
        final String? uploadedUrl = await _profileController.uploadAvatar(File(image.path));
        if (uploadedUrl != null) {
          await _profileController.updateUserInfo(avatar: uploadedUrl);
        }
      }
    } catch (e) {
      print('Pick image error: $e');
      Get.snackbar('错误', '选择图片失败');
    }
  }
}

// 添加这个委托类来处理 Tab 栏的吸附效果
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => 44;
  @override
  double get maxExtent => 44;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
