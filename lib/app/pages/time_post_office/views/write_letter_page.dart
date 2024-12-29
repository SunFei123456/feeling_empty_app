import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_study/app/pages/time_post_office/views/write_letter_content_page.dart';
import 'package:lottie/lottie.dart';

class WriteLetterPage extends StatefulWidget {
  const WriteLetterPage({Key? key}) : super(key: key);

  @override
  State<WriteLetterPage> createState() => _WriteLetterPageState();
}

class _WriteLetterPageState extends State<WriteLetterPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedTag = '生活';
  String _customTag = '';
  bool _isCustomTag = false;

  final List<String> _predefinedTags = ['生活', '工作', '学习', '情感', '其他'];
  
  // 添加主题颜色常量
  static const List<Color> _themeColors = [
    Color(0xFFFF6B6B),  // 珊瑚红
    Color(0xFF4ECDC4),  // 薄荷绿
    Color(0xFFFFBE0B),  // 向日葵黄
    Color(0xFF845EC2),  // 梦幻紫
    Color(0xFF00B8A9),  // 孔雀绿
  ];
  
  int _selectedColorIndex = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '写给未来的信',
          style: TextStyle(
            color: Color(0xFF2D3142),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.grey),
            onPressed: _showTipsDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          // 背景装饰
          Positioned(
            right: -50,
            top: -30,
            child: Transform.rotate(
              angle: 0.2,
              child: Icon(
                Icons.mail_outline,
                size: 200,
                color: _themeColors[_selectedColorIndex].withOpacity(0.1),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 信封样式容器
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                    border: Border.all(
                      color: _themeColors[_selectedColorIndex].withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      // 主题色选择器
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _themeColors.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => setState(() => _selectedColorIndex = index),
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: _themeColors[index],
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _selectedColorIndex == index 
                                        ? Colors.white 
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    if (_selectedColorIndex == index)
                                      BoxShadow(
                                        color: _themeColors[index].withOpacity(0.4),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                      ),
                                  ],
                                ),
                                child: _selectedColorIndex == index
                                    ? const Icon(Icons.check, color: Colors.white)
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 标题输入框
                      _buildTextField(
                        controller: _titleController,
                        label: '标题',
                        hint: '给这封信起个温暖的标题吧~',
                        maxLength: 50,
                        prefixIcon: Icon(
                          Icons.title,
                          color: _themeColors[_selectedColorIndex],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 内容输入框
                      _buildTextField(
                        controller: _contentController,
                        label: '前置语',
                        hint: '写下你想对未来说的话...',
                        maxLines: 3,
                        maxLength: 200,
                        prefixIcon: Icon(
                          Icons.edit_note,
                          color: _themeColors[_selectedColorIndex],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
                // 添加去编写信封区域
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.edit_document,
                            color: _themeColors[_selectedColorIndex],
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            '编写信封内容',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '点击下方按钮开始编写信封内容',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => Get.to(() => WriteLetterContentPage(
                            title: _titleController.text,
                            preContent: _contentController.text,
                            tag: _selectedTag,
                            themeColor: _themeColors[_selectedColorIndex],
                          )),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _themeColors[_selectedColorIndex],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "去编写信封",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                // 标签选择区域
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.label_outline,
                            color: _themeColors[_selectedColorIndex],
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            '为信件添加标签',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ..._predefinedTags.map((tag) => _buildTagChip(tag)),
                          _buildCustomTagChip(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleSubmit,
        backgroundColor: _themeColors[_selectedColorIndex],
        icon: const Icon(Icons.send),
        label: const Text('寄出信件'),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    int? maxLength,
    Widget? prefixIcon,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: _themeColors[_selectedColorIndex].withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: _themeColors[_selectedColorIndex],
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    final isSelected = !_isCustomTag && _selectedTag == tag;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ChoiceChip(
        label: Text(tag),
        selected: isSelected,
        selectedColor: _themeColors[_selectedColorIndex].withOpacity(0.2),
        backgroundColor: Colors.grey[100],
        labelStyle: TextStyle(
          color: isSelected
              ? _themeColors[_selectedColorIndex]
              : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (selected) {
          setState(() {
            _isCustomTag = false;
            _selectedTag = tag;
          });
        },
        avatar: isSelected
            ? Icon(
                Icons.check_circle,
                size: 18,
                color: _themeColors[_selectedColorIndex],
              )
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  Widget _buildCustomTagChip() {
    return ChoiceChip(
      label: _isCustomTag
          ? SizedBox(
              width: 80,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _customTag = value;
                    _selectedTag = value;
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(fontSize: 14),
              ),
            )
          : const Text('自定义'),
      selected: _isCustomTag,
      selectedColor: _themeColors[_selectedColorIndex].withOpacity(0.2),
      backgroundColor: Colors.grey[100],
      labelStyle: TextStyle(
        color: _isCustomTag
            ? _themeColors[_selectedColorIndex]
            : Colors.grey[700],
      ),
      onSelected: (selected) {
        setState(() {
          _isCustomTag = selected;
          if (selected) {
            _selectedTag = _customTag;
          }
        });
      },
    );
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
    
    // 跳转到信件内容编辑页面
    Get.to(() => WriteLetterContentPage(
      title: _titleController.text,
      preContent: _contentController.text,
      tag: _selectedTag,
      themeColor: _themeColors[_selectedColorIndex],
    ))?.then((result) {
      if (result != null) {
        // TODO: 处理完整的信件数据保存
        Get.snackbar(
          '成功',
          '信件已保存',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
          icon: const Icon(Icons.check_circle, color: Colors.green),
        );
        Get.back(); // 返回上一页
      }
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
