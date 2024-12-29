import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

enum BottleType { text, image, audio }

class WriteBottlePage extends StatefulWidget {
  const WriteBottlePage({Key? key}) : super(key: key);

  @override
  State<WriteBottlePage> createState() => _WriteBottlePageState();
}

class _WriteBottlePageState extends State<WriteBottlePage> {
  final _contentController = TextEditingController();
  BottleType _selectedType = BottleType.text;
  
  // 图片相关
  final _imagePicker = ImagePicker();
  XFile? _selectedImage;
  
  // 录音相关
  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();
  String? _recordedFilePath;
  bool _isRecording = false;
  bool _isPlaying = false;
  Duration _recordDuration = Duration.zero;
  Timer? _recordTimer;
  String? _selectedMood;
  String? _selectedTopic;
  final TextEditingController _customTopicController = TextEditingController();
  bool _isAddingCustomTopic = false;

  @override
  void dispose() {
    _contentController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _recordTimer?.cancel();
    _customTopicController.dispose();
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
            Icons.close,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          '写漂流瓶',
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
                color: isDark ? Colors.blue[200] : Colors.blue,
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
            // 类型选择
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildTypeButton(
                    type: BottleType.text,
                    icon: Icons.text_fields,
                    label: '文字',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 12),
                  _buildTypeButton(
                    type: BottleType.image,
                    icon: Icons.image,
                    label: '图文',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 12),
                  _buildTypeButton(
                    type: BottleType.audio,
                    icon: Icons.mic,
                    label: '音文',
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 内容编辑区
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
                children: [
                  TextField(
                    controller: _contentController,
                    maxLines: 5,
                    maxLength: 200,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: '写下你想说的话...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  if (_selectedType != BottleType.text) ...[
                    const Divider(),
                    const SizedBox(height: 12),
                    _buildMediaSection(isDark),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 情绪标签
            _buildMoodTags(isDark),
            const SizedBox(height: 20),
            // 话题选择
            _buildTopicSelector(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required BottleType type,
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? Colors.blue[900] : Colors.blue[50])
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? (isDark ? Colors.blue[200] : Colors.blue)
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? (isDark ? Colors.blue[200] : Colors.blue)
                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaSection(bool isDark) {
    switch (_selectedType) {
      case BottleType.image:
        return _buildImageSection(isDark);
      case BottleType.audio:
        return _buildAudioSection(isDark);
      default:
        return const SizedBox();
    }
  }

  Widget _buildImageSection(bool isDark) {
    if (_selectedImage == null) {
      return InkWell(
        onTap: _pickImage,
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 32,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              const SizedBox(height: 8),
              Text(
                '添加图片',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(_selectedImage!.path),
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: InkWell(
            onTap: () => setState(() => _selectedImage = null),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAudioSection(bool isDark) {
    return Column(
      children: [
        if (_recordedFilePath == null)
          InkWell(
            onTap: _isRecording ? _stopRecording : _startRecording,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    size: 32,
                    color: _isRecording
                        ? Colors.red
                        : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isRecording ? '点击停止' : '点击录音',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  if (_isRecording) ...[
                    const SizedBox(height: 8),
                    Text(
                      _formatDuration(_recordDuration),
                      style: TextStyle(
                        color: isDark ? Colors.red[200] : Colors.red,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: _playRecording,
                  icon: Icon(
                    _isPlaying ? Icons.stop : Icons.play_arrow,
                    color: isDark ? Colors.blue[200] : Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '录音完成',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _recordedFilePath = null),
                  icon: Icon(
                    Icons.delete_outline,
                    color: isDark ? Colors.red[200] : Colors.red,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMoodTags(bool isDark) {
    final List<Map<String, dynamic>> moods = [
      {'emoji': '😊', 'label': '开心', 'color': Colors.yellow},
      {'emoji': '😢', 'label': '难过', 'color': Colors.blue},
      {'emoji': '🤔', 'label': '思考', 'color': Colors.purple},
      {'emoji': '😠', 'label': '生气', 'color': Colors.red},
      {'emoji': '🥳', 'label': '期待', 'color': Colors.orange},
      {'emoji': '😴', 'label': '疲惫', 'color': Colors.grey},
      {'emoji': '🥰', 'label': '喜欢', 'color': Colors.pink},
      {'emoji': '😮', 'label': '惊讶', 'color': Colors.green},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '选择心情',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: moods.length,
          itemBuilder: (context, index) {
            final mood = moods[index];
            final isSelected = _selectedMood == mood['label'];
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMood = isSelected ? null : mood['label'];
                });
                // 添加触感反馈
                HapticFeedback.lightImpact();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? mood['color'].withOpacity(isDark ? 0.3 : 0.1)
                      : (isDark ? Colors.grey[900] : Colors.grey[100]),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? mood['color']
                        : (isDark ? Colors.grey[800]! : Colors.grey[300]!),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: mood['color'].withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 添加缩放动画
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 1.0, end: isSelected ? 1.2 : 1.0),
                      duration: const Duration(milliseconds: 200),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Text(
                            mood['emoji'],
                            style: const TextStyle(fontSize: 28),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mood['label'],
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? mood['color']
                            : (isDark ? Colors.grey[400] : Colors.grey[600]),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTopicSelector(bool isDark) {
    final List<String> predefinedTopics = [
      '日常生活', '学习心得', '职场故事', 
      '恋爱物语', '美食分享', '旅行记录',
      '深夜感悟', '趣事分享', '音乐推荐',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '选择话题',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _isAddingCustomTopic = true;
                });
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                    title: Text(
                      '添加自定义话题',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    content: TextField(
                      controller: _customTopicController,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: '输入话题名称（不超过6个字）',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          '取消',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_customTopicController.text.isNotEmpty) {
                            setState(() {
                              _selectedTopic = _customTopicController.text;
                            });
                            _customTopicController.clear();
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          '确定',
                          style: TextStyle(
                            color: isDark ? Colors.blue[200] : Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(
                Icons.add_circle_outline,
                size: 18,
                color: isDark ? Colors.blue[200] : Colors.blue,
              ),
              label: Text(
                '自定义话题',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.blue[200] : Colors.blue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...predefinedTopics.map((topic) => _buildTopicChip(topic, isDark)),
            if (_selectedTopic != null && !predefinedTopics.contains(_selectedTopic))
              _buildTopicChip(_selectedTopic!, isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildTopicChip(String topic, bool isDark) {
    final isSelected = _selectedTopic == topic;
    return FilterChip(
      selected: isSelected,
      showCheckmark: false,
      label: Text(topic),
      labelStyle: TextStyle(
        color: isSelected
            ? (isDark ? Colors.blue[200] : Colors.blue)
            : (isDark ? Colors.grey[300] : Colors.grey[700]),
        fontSize: 14,
      ),
      backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
      selectedColor: isDark ? Colors.blue[900]!.withOpacity(0.3) : Colors.blue[50],
      side: BorderSide(
        color: isSelected
            ? (isDark ? Colors.blue[700]! : Colors.blue[200]!)
            : Colors.transparent,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onSelected: (selected) {
        setState(() {
          _selectedTopic = selected ? topic : null;
        });
        HapticFeedback.lightImpact();
      },
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/recorded_audio.m4a';
        await _audioRecorder.start(
          RecordConfig(),
          path: filePath,
        );
        setState(() {
          _isRecording = true;
          _recordDuration = Duration.zero;
        });
        _startTimer();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _recordedFilePath = path;
      });
      _recordTimer?.cancel();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _playRecording() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.stop();
        setState(() => _isPlaying = false);
      } else {
        await _audioPlayer.play(DeviceFileSource(_recordedFilePath!));
        setState(() => _isPlaying = true);
        
        _audioPlayer.onPlayerComplete.listen((event) {
          setState(() => _isPlaying = false);
        });
      }
    } catch (e) {
      print('播放错误: $e');
    }
  }

  void _startTimer() {
    _recordTimer?.cancel();
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration += const Duration(seconds: 1));
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _handleSubmit() {
    if (_contentController.text.isEmpty) {
      Get.snackbar('提示', '请输入内容');
      return;
    }

    if (_selectedType == BottleType.image && _selectedImage == null) {
      Get.snackbar('提示', '请选择图片');
      return;
    }

    if (_selectedType == BottleType.audio && _recordedFilePath == null) {
      Get.snackbar('提示', '请录制语音');
      return;
    }

    // TODO: 处理发布逻辑
    Get.back(result: {
      'type': _selectedType.toString(),
      'content': _contentController.text,
      'media': _selectedType == BottleType.image
          ? _selectedImage?.path
          : _recordedFilePath,
    });
  }
} 