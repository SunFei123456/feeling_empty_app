import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

enum LetterType { text, image, audio }

class WriteLetterContentPage extends StatefulWidget {
  final String title;
  final String preContent;
  final String tag;
  final Color themeColor;
  final Map<String, dynamic>? initialContent;
  final bool readOnly;

  const WriteLetterContentPage({
    Key? key,
    required this.title,
    required this.preContent,
    required this.tag,
    required this.themeColor,
    this.initialContent,
    this.readOnly = false,
  }) : super(key: key);

  @override
  State<WriteLetterContentPage> createState() => _WriteLetterContentPageState();
}

class _WriteLetterContentPageState extends State<WriteLetterContentPage> {
  final _letterController = TextEditingController();
  LetterType _selectedType = LetterType.text;
  DateTime? _selectedDate;
  
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

  @override
  void initState() {
    super.initState();
    // 如果有初始内容，加载它
    if (widget.initialContent != null) {
      _letterController.text = widget.initialContent!['content'] ?? '';
      _selectedType = _getTypeFromString(widget.initialContent!['type']);
      _selectedDate = DateTime.parse(widget.initialContent!['unlockTime']);
      
      // 加载媒体内容
      if (widget.initialContent!['media'] != null) {
        if (_selectedType == LetterType.image) {
          _selectedImage = XFile(widget.initialContent!['media']);
        } else if (_selectedType == LetterType.audio) {
          _recordedFilePath = widget.initialContent!['media'];
        }
      }
    }
  }

  // 添加辅助方法来转换类型
  LetterType _getTypeFromString(String? type) {
    switch (type) {
      case 'image':
        return LetterType.image;
      case 'audio':
        return LetterType.audio;
      default:
        return LetterType.text;
    }
  }

  @override
  void dispose() {
    _letterController.dispose();
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
          '写信内容',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!widget.readOnly)  // 只在编辑模式显示完成按钮
            TextButton(
              onPressed: _handleSubmit,
              child: Text(
                '完成',
                style: TextStyle(
                  color: widget.themeColor,
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
                    type: LetterType.text,
                    icon: Icons.text_fields,
                    label: '文字',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 12),
                  _buildTypeButton(
                    type: LetterType.image,
                    icon: Icons.image,
                    label: '图文',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 12),
                  _buildTypeButton(
                    type: LetterType.audio,
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
                    controller: _letterController,
                    maxLines: 8,
                    maxLength: 500,
                    readOnly: widget.readOnly,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.readOnly ? '' : '写下你想对未来说的话...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  if (_selectedType != LetterType.text) ...[
                    const Divider(),
                    const SizedBox(height: 12),
                    _buildMediaSection(isDark),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 开启时间选择
            _buildDateSelector(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required LetterType type,
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: InkWell(
        onTap: widget.readOnly ? null : () => setState(() => _selectedType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? widget.themeColor.withOpacity(isDark ? 0.2 : 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? widget.themeColor
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? widget.themeColor
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
      case LetterType.image:
        return _buildImageSection(isDark);
      case LetterType.audio:
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
                    color: widget.themeColor,
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

  Widget _buildDateSelector(bool isDark) {
    return Container(
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
            '选择开启时间',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: widget.readOnly ? null : () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now().add(const Duration(days: 1)),
                lastDate: DateTime.now().add(const Duration(days: 3650)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: widget.themeColor,
                        onPrimary: Colors.white,
                        onSurface: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null && picked != _selectedDate) {
                setState(() => _selectedDate = picked);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: widget.themeColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _selectedDate == null
                        ? '选择日期'
                        : '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
        final filePath = '${directory.path}/recorded_letter.m4a';
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
      Get.snackbar(
        '提示',
        '录音失败，请检查权限设置',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
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
      Get.snackbar(
        '提示',
        '播放失败',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
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
    if (_letterController.text.isEmpty) {
      Get.snackbar(
        '提示',
        '请输入信件内容',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (_selectedType == LetterType.image && _selectedImage == null) {
      Get.snackbar(
        '提示',
        '请选择图片',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (_selectedType == LetterType.audio && _recordedFilePath == null) {
      Get.snackbar(
        '提示',
        '请录制语音',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (_selectedDate == null) {
      Get.snackbar(
        '提示',
        '请选择开启时间',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    // 返回结果
    Get.back(result: {
      'type': _selectedType == LetterType.text 
          ? 'text'
          : _selectedType == LetterType.image
              ? 'image'
              : 'audio',
      'content': _letterController.text,
      'media': _selectedType == LetterType.image
          ? _selectedImage?.path
          : _recordedFilePath,
      'unlockTime': _selectedDate!.toIso8601String(),
      'title': widget.title,
      'preContent': widget.preContent,
      'tag': widget.tag,
    });
  }
} 