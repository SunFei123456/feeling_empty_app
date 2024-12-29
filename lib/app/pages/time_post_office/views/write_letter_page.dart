import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_study/app/pages/time_post_office/views/write_letter_content_page.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class WriteLetterPage extends StatefulWidget {
  const WriteLetterPage({Key? key}) : super(key: key);

  @override
  State<WriteLetterPage> createState() => _WriteLetterPageState();
}

class _WriteLetterPageState extends State<WriteLetterPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedTag = '生活';
  String _customTag = '';
  bool _isCustomTag = false;

  final List<String> _predefinedTags = ['生活', '工作', '学习', '情感', '其他'];

  // 添加主题颜色常量
  static const List<Color> _themeColors = [
    Color(0xFFFF6B6B), // 珊瑚红
    Color(0xFF4ECDC4), // 薄荷绿
    Color(0xFFFFBE0B), // 向日葵黄
    Color(0xFF845EC2), // 梦幻紫
    Color(0xFF00B8A9), // 孔雀绿
  ];

  int _selectedColorIndex = 0;

  // 添加内容相关的状态
  bool _isRecording = false;
  bool _isPlaying = false;
  Duration _recordDuration = Duration.zero;
  Timer? _recordTimer;
  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();

  // 在 _WriteLetterPageState 类中添加状态
  bool _hasWrittenLetter = false;
  Map<String, dynamic>? _letterContent;  // 存储信件内容

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _recordTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          '写时光信',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _handleSubmit,
            child: Text(
              '发布',
              style: TextStyle(
                color: _themeColors[_selectedColorIndex],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 主题色选择
            Text(
              '选择主题色',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _themeColors.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => _buildColorItem(index, isDark),
              ),
            ),
            const SizedBox(height: 30),
            // 标题输入
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '信件标题',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _titleController,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: '给信件起个标题吧',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: _themeColors[_selectedColorIndex],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 前置语输入
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '前置语',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _contentController,
                    maxLines: 3,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: '写一段简短的介绍，会显示在信件列表中',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: _themeColors[_selectedColorIndex],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 标签选择
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '选择标签',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _buildTags(isDark),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 编写信封区域
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.grey[900]!.withOpacity(0.5)
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                ),
              ),
              child: Stack(
                children: [
                  // 信封背景图标
                  Positioned.fill(
                    child: Icon(
                      Icons.mail_outline,
                      size: 100,
                      color: _themeColors[_selectedColorIndex].withOpacity(0.1),
                    ),
                  ),
                  Column(
                    children: [
                      // 信封标题
                      Row(
                        children: [
                          Icon(
                            Icons.mail,
                            color: _themeColors[_selectedColorIndex],
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '编写信封内容',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // 提示文字
                      Text(
                        '在这里写下你想对未来说的话',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 编写按钮
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_hasWrittenLetter) {
                              // 查看已写的信封
                              Get.to(() => WriteLetterContentPage(
                                title: _titleController.text,
                                preContent: _contentController.text,
                                tag: _selectedTag ?? '其他',
                                themeColor: _themeColors[_selectedColorIndex],
                                initialContent: _letterContent,  // 传递已有内容
                                readOnly: true,  // 添加只读模式
                              ));
                            } else {
                              // 编写新信封
                              Get.to(() => WriteLetterContentPage(
                                title: _titleController.text,
                                preContent: _contentController.text,
                                tag: _selectedTag ?? '其他',
                                themeColor: _themeColors[_selectedColorIndex],
                              ))?.then((result) {
                                if (result != null) {
                                  setState(() {
                                    _hasWrittenLetter = true;
                                    _letterContent = result;
                                  });
                                }
                              });
                            }
                          },
                          icon: Icon(_hasWrittenLetter ? Icons.visibility : Icons.edit),
                          label: Text(_hasWrittenLetter ? '查看信封' : '开始编写'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _themeColors[_selectedColorIndex],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildColorItem(int index, bool isDark) {
    final isSelected = _selectedColorIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedColorIndex = index),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: _themeColors[index],
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? Colors.grey[800]! : Colors.white,
            width: 3,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: _themeColors[index].withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
          ],
        ),
        child: isSelected
            ? const Icon(
                Icons.check,
                color: Colors.white,
              )
            : null,
      ),
    );
  }

  List<Widget> _buildTags(bool isDark) {
    return ['生活', '工作', '学习', '情感', '旅行', '美食', '运动', '音乐', '电影', '阅读', '其他']
        .map((tag) {
      final isSelected = _selectedTag == tag;
      return FilterChip(
        selected: isSelected,
        label: Text(tag),
        onSelected: (selected) {
          setState(() => _selectedTag = selected ? tag : null);
          HapticFeedback.lightImpact();
        },
        backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
        selectedColor: _themeColors[_selectedColorIndex].withOpacity(0.2),
        checkmarkColor: _themeColors[_selectedColorIndex],
        labelStyle: TextStyle(
          color: isSelected
              ? _themeColors[_selectedColorIndex]
              : (isDark ? Colors.grey[300] : Colors.grey[700]),
        ),
        side: BorderSide(
          color: isSelected
              ? _themeColors[_selectedColorIndex]
              : Colors.transparent,
        ),
      );
    }).toList();
  }

  void _handleSubmit() {
    if (_titleController.text.isEmpty) {
      Get.snackbar(
        '提示',
        '请输入标题',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
      return;
    }
    if (_contentController.text.isEmpty) {
      Get.snackbar(
        '提示',
        '请输入前置语',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
      return;
    }

    // TODO: 处理发布逻辑
    Get.back(result: {
      'title': _titleController.text,
      'preContent': _contentController.text,
      'tag': _selectedTag ?? '其他',
      'themeColor': _themeColors[_selectedColorIndex],
    });
  }

  void _showTipsDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/letter_tips.json',
                height: 150,
                repeat: true,
              ),
              const Text(
                '写信小贴士',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                '1. 选择一个喜欢的主题色\n'
                '2. 写下温暖有趣的标题\n'
                '3. 添加简短的前置语\n'
                '4. 选择合适的标签\n'
                '5. 点击下一步编写信件内容',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('知道了'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
