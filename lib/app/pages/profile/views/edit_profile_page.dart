import 'dart:io';
import 'package:fangkong_xinsheng/app/router/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fangkong_xinsheng/app/pages/profile/controller/profile_controller.dart';

class EditProfilePage extends StatefulWidget {
  final String? tag;

  const EditProfilePage({
    Key? key,
    this.tag = 'current_user',
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final ProfileController _profileController;
  final _nicknameController = TextEditingController();
  int _selectedSex = 0;
  String? _tempAvatarUrl; // 临时头像地址

  @override
  void initState() {
    super.initState();
    // 使用 tag 查找正确的 controller 实例
    _profileController = Get.find<ProfileController>(tag: widget.tag);

    // 初始化表单数据
    _nicknameController.text = _profileController.user.value?.nickname ?? '';
    _selectedSex = _profileController.user.value?.sex ?? 0;
    _tempAvatarUrl = _profileController.user.value?.avatar;
  }

  @override
  void dispose() {
    // 释放资源
    _nicknameController.dispose();
    super.dispose();
  }

  void _showImagePickerBottomSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _buildPickerOption(
              icon: Icons.photo_camera,
              title: '拍照',
              subtitle: '使用相机拍摄新照片',
              color: Colors.blue,
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _buildPickerOption(
              icon: Icons.photo_library,
              title: '从相册选择',
              subtitle: '从手机相册中选择照片',
              color: Colors.green,
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
              isDark: isDark,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
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
        final String? uploadedUrl =
            await _profileController.uploadAvatar(File(image.path));
        if (uploadedUrl != null) {
          setState(() {
            _tempAvatarUrl = uploadedUrl;
          });
        }
      }
    } catch (e) {
      print('Pick image error: $e');
      Get.snackbar('错误', '选择图片失败');
    }
  }

  Future<void> _saveProfile() async {
    try {
      // 显示加载状态
      setState(() => _profileController.isLoading.value = true);
      
      await _profileController.updateUserInfo(
        avatar: _tempAvatarUrl,
        nickname: _nicknameController.text,
        sex: _selectedSex,
      );

      // 确保更新成功后再返回
      await _profileController.fetchUserInfo();
      
      // 使用 AppRoutes.back 而不是 Get.back
      AppRoutes.back(result: true);
    } catch (e) {
      print('Save profile error: $e');
      Get.snackbar('错误', '保存失败');
    } finally {
      // 恢复加载状态
      setState(() => _profileController.isLoading.value = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      appBar: AppBar(
        title: Text(
          '修改信息',
          style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? Colors.black : Colors.white,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
        actions: [
          TextButton.icon(
            onPressed: _saveProfile,
            label: Text(
              '保存',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final isLoading = _profileController.isLoading.value;

        if (isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头像
              Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: _showImagePickerBottomSheet,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: _tempAvatarUrl != null &&
                                    _tempAvatarUrl!.isNotEmpty
                                ? NetworkImage(_tempAvatarUrl!)
                                : const AssetImage('assets/images/avatar.jpg')
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: isDark ? Colors.white24 : Colors.orange,
                            width: 4,
                          ),
                          boxShadow: [
                            if (!isDark)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white24 : Colors.black87,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? Colors.black87 : Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            if (!isDark)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                          ],
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: isDark ? Colors.black87 : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 昵称
              Text(
                '昵称',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color:
                      isDark ? Colors.white.withOpacity(0.1) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _nicknameController,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: '请输入昵称',
                    hintStyle: TextStyle(
                      color: isDark
                          ? Colors.white.withOpacity(0.5)
                          : Colors.grey[500],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 性别选择
              Text(
                '性别',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildGenderCard(
                      icon: Icons.male,
                      label: '男生',
                      value: 1,
                      color: Colors.blue,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildGenderCard(
                      icon: Icons.female,
                      label: '女生',
                      value: 2,
                      color: Colors.pink,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildGenderCard({
    required IconData icon,
    required String label,
    required int value,
    required Color color,
    required bool isDark,
  }) {
    final isSelected = _selectedSex == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedSex = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? color.withOpacity(0.2) : color.withOpacity(0.1))
              : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDark ? color.withOpacity(0.5) : color)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected
                  ? (isDark ? color.withOpacity(0.9) : color)
                  : (isDark ? Colors.white38 : Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? (isDark ? color.withOpacity(0.9) : color)
                    : (isDark ? Colors.white38 : Colors.grey[600]),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? color.withOpacity(0.2) : color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isDark ? Colors.white60 : Colors.grey[600],
        ),
      ),
      onTap: onTap,
    );
  }
}
