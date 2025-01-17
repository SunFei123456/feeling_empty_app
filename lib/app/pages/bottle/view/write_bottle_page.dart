import 'package:fangkong_xinsheng/app/pages/bottle/api/index.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/model/index.dart';
import 'package:fangkong_xinsheng/app/pages/views/api/topic_api.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/ocean.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:fangkong_xinsheng/app/pages/views/api/ocean_api.dart';

enum BottleType { text, image, audio }

class WriteBottlePage extends StatefulWidget {
  final String? defaultTopic;
  final int? defaultTopicId;

  const WriteBottlePage({
    Key? key,
    this.defaultTopic,
    this.defaultTopicId,
  }) : super(key: key);

  @override
  State<WriteBottlePage> createState() => _WriteBottlePageState();
}

class _WriteBottlePageState extends State<WriteBottlePage> {
  final _contentController = TextEditingController();
  final _titleController = TextEditingController();
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
  bool _isPublic = true;
  final OceanApiService _oceanApi = OceanApiService();
  List<Ocean> _oceans = [];
  Ocean? _selectedOcean;
  int? _selectedTopicId;

  @override
  void initState() {
    super.initState();
    _loadOceans();
    if (widget.defaultTopic != null) {
      _selectedTopic = widget.defaultTopic;
      _selectedTopicId = widget.defaultTopicId;
    }
  }

  Future<void> _loadOceans() async {
    try {
      final response = await _oceanApi.getOceans();
      if (response.success && response.data != null) {
        setState(() {
          _oceans = response.data!;
          _selectedOcean = _oceans.first;
        });
      } else {
        print('加载海域失败: ${response.message}');
      }
    } catch (e) {
      print('加载海域失败: $e');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
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
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'write_a_drift_bottle'.tr,
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
              'publish'.tr,
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'publish_bottle_title'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                maxLength: 30,
              ),
            ),
            const SizedBox(height: 16),
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
                    label: 'bottle_type_text',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 12),
                  _buildTypeButton(
                    type: BottleType.image,
                    icon: Icons.image,
                    label: 'bottle_type_image',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 12),
                  _buildTypeButton(
                    type: BottleType.audio,
                    icon: Icons.mic,
                    label: 'bottle_type_voice',
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
                      hintText: 'write_words'.tr,
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
            const SizedBox(height: 20),
            _buildOceanSelector(isDark),
            const SizedBox(height: 20),
            _buildPublicSwitch(isDark),
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
                label.tr,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '录音完成',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _formatDuration(_recordDuration),
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _recordedFilePath = null;
                      _recordDuration = Duration.zero;
                    });
                  },
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
      {
        'emoji': '😊',
        'label': 'happy',
        'value': BottleMood.happy.name,
        'color': Colors.yellow
      },
      {
        'emoji': '😢',
        'label': 'sad',
        'value': BottleMood.sad.name,
        'color': Colors.blue
      },
      {
        'emoji': '🤔',
        'label': 'thinking',
        'value': BottleMood.thinking.name,
        'color': Colors.purple
      },
      {
        'emoji': '😠',
        'label': 'angry',
        'value': BottleMood.angry.name,
        'color': Colors.red
      },
      {
        'emoji': '🥳',
        'label': 'excited',
        'value': BottleMood.excited.name,
        'color': Colors.orange
      },
      {
        'emoji': '😴',
        'label': 'tired',
        'value': BottleMood.tired.name,
        'color': Colors.grey
      },
      {
        'emoji': '🥰',
        'label': 'love',
        'value': BottleMood.love.name,
        'color': Colors.pink
      },
      {
        'emoji': '😮',
        'label': 'surprised',
        'value': BottleMood.surprised.name,
        'color': Colors.green
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'choose_mood'.tr,
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
              mainAxisSpacing: 12),
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
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
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
    List<Map<String, dynamic>> predefinedTopics = [
      {"id": 1, "title": "日常生活"},
      {"id": 2, "title": "学习心得"},
      {"id": 3, "title": "职场故事"},
      {"id": 4, "title": "恋爱物语"},
      {"id": 5, "title": "美食分享"},
      {"id": 6, "title": "旅行记录"},
      {"id": 7, "title": "深夜感悟"},
      {"id": 8, "title": "趣事分享"},
      {"id": 9, "title": "音乐推荐"},
    ];

    if (widget.defaultTopic != null && widget.defaultTopicId != null) {
      if (!predefinedTopics
          .any((topic) => topic['id'] == widget.defaultTopicId)) {
        predefinedTopics.add({
          "id": widget.defaultTopicId!,
          "title": widget.defaultTopic!,
        });
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'choose_topic'.tr,
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
                      'add_customize_topic'.tr,
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
                        hintText: 'input_topic_name'.tr,
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                isDark ? Colors.grey[700]! : Colors.grey[300]!,
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'cancel'.tr,
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_customTopicController.text.isNotEmpty) {
                            // 调取接口
                            final res = await TopicApiService()
                                .createTopic(_customTopicController.text);

                            if (res.success) {
                              Get.snackbar('成功', '话题添加成功');

                              setState(() {
                                _selectedTopic = _customTopicController.text;
                                _selectedTopicId = res.data['id'];
                              });
                            } else {
                              Get.snackbar('失败', '话题添加失败');
                            }
                            _customTopicController.clear();
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          'confirm'.tr,
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
                'customize_topic'.tr,
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
          spacing: 12,
          runSpacing: 8,
          children: [
            ...predefinedTopics.map((topic) => _buildTopicChip(topic, isDark)),
            if (_selectedTopic != null &&
                !predefinedTopics
                    .any((topic) => topic['title'] == _selectedTopic))
              _buildTopicChip(_selectedTopic!, isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildTopicChip(dynamic topic, bool isDark) {
    final String topicTitle =
        topic is Map ? topic['title'] as String : topic as String;
    final isSelected = _selectedTopic == topicTitle;

    return FilterChip(
      selected: isSelected,
      showCheckmark: false,
      label: Text(topicTitle),
      labelStyle: TextStyle(
        color: isSelected
            ? (isDark ? Colors.blue[200] : Colors.blue)
            : (isDark ? Colors.grey[300] : Colors.grey[700]),
        fontSize: 14,
      ),
      backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
      selectedColor:
          isDark ? Colors.blue[900]!.withOpacity(0.3) : Colors.blue[50],
      side: BorderSide(
        color: isSelected
            ? (isDark ? Colors.blue[700]! : Colors.blue[200]!)
            : Colors.transparent,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onSelected: (selected) {
        setState(() {
          _selectedTopic = selected ? topicTitle : null;
          _selectedTopicId =
              selected && topic is Map ? topic['id'] as int : null;
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

  void _handleSubmit() async {
    if (_contentController.text.isEmpty &&
        _selectedImage == null &&
        _recordedFilePath == null) {
      Get.snackbar('提示', '请输入内容或添加媒体文件');
      return;
    }

    if (_selectedMood == null) {
      Get.snackbar('提示', '请选择心情');
      return;
    }

    if (_selectedOcean == null) {
      Get.snackbar('提示', '请选择投放海域');
      return;
    }

    try {
      final bottleApi = BottleApiService();
      String? imageUrl;
      String? audioUrl;

      // 上传图片（如果有）
      if (_selectedImage != null) {
        final imageResponse = await bottleApi.uploadImage(_selectedImage!.path);
        if (imageResponse.success) {
          imageUrl = imageResponse.data;
        } else {
          throw Exception('图片上传失败: ${imageResponse.message}');
        }
      }

      // 上传音频（如果有）
      if (_recordedFilePath != null) {
        final audioResponse = await bottleApi.uploadAudio(_recordedFilePath!);
        if (audioResponse.success) {
          audioUrl = audioResponse.data;
        } else {
          throw Exception('音频上传失败: ${audioResponse.message}');
        }
      }

      // 创建漂流瓶请求
      final request = CreateBottleRequest(
        content: _contentController.text,
        imageUrl: imageUrl,
        audioUrl: audioUrl,
        mood: _selectedMood!,
        isPublic: _isPublic,
        topicId: _selectedTopicId,
        title: _titleController.text,
        oceanId: _selectedOcean!.id,
      );

      // 发送创建请求
      final response = await bottleApi.createBottle(request);
      if (response.success) {
        Get.back();
        Get.snackbar('成功', '漂流瓶已发布');
      } else {
        throw Exception(response.message ?? '发布失败');
      }
    } catch (e) {
      print('发布错误: $e');
      Get.snackbar('错误', e.toString());
    }
  }

  Widget _buildPublicSwitch(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'public_drift_bottle',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Switch(
            value: _isPublic,
            onChanged: (value) => setState(() => _isPublic = value),
            activeColor: isDark ? Colors.blue[200] : Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildOceanSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'choose_drop_sea_area'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: _oceans.isEmpty
              ? Center(
                  child: Text(
                    '加载海域中...',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _oceans.length,
                  itemBuilder: (context, index) {
                    final ocean = _oceans[index];
                    final isSelected = _selectedOcean?.id == ocean.id;

                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedOcean = ocean);
                      },
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? (isDark ? Colors.blue[400]! : Colors.blue)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                ocean.bg,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: isDark
                                        ? Colors.grey[800]
                                        : Colors.grey[200],
                                    child: Icon(
                                      Icons.broken_image,
                                      color: isDark
                                          ? Colors.grey[600]
                                          : Colors.grey[400],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              right: 8,
                              child: Text(
                                ocean.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
