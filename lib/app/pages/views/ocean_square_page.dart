import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:fangkong_xinsheng/app/pages/square/views/bottle_card_detail.dart';
import 'dart:math' show sin;
import 'dart:ui';
import 'package:fangkong_xinsheng/app/pages/views/api/ocean_api.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/ocean.dart';

class OceanSquarePage extends StatefulWidget {
  @override
  State<OceanSquarePage> createState() => _OceanSquarePageState();
}

class _OceanSquarePageState extends State<OceanSquarePage> {
  final OceanApiService _oceanApi = OceanApiService();
  List<Ocean> _oceans = [];
  List<BottleModel> _bottles = [];
  Ocean? _currentOcean;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOceans();
  }

  Future<void> _loadOceans() async {
    try {
      final response = await _oceanApi.getOceans();
      if (response.success && response.data != null) {
        setState(() {
          _oceans = response.data!;
          if (_oceans.isNotEmpty) {
            _currentOcean = _oceans.first;
            _loadBottles(_currentOcean!.id);
          }
        });
      }
    } catch (e) {
      print('加载海域失败: $e');
    }
  }

  Future<void> _loadBottles(int oceanId) async {
    setState(() => _isLoading = true);
    try {
      final response = await _oceanApi.getBottlesByOceanId(oceanId);
      if (response.success && response.data != null) {
        setState(() {
          _bottles = response.data!;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('加载漂流瓶失败: $e');
      setState(() => _isLoading = false);
    }
  }

  Widget _buildOceanHeader() {
    if (_currentOcean == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          PopupMenuButton<Ocean>(
            offset: const Offset(0, 40),
            color: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.water_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _currentOcean!.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_currentOcean!.bottleCount}个漂流瓶',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem<Ocean>(
                enabled: false,
                height: 0,
                padding: EdgeInsets.zero,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _oceans.map((ocean) {
                          return InkWell(
                            onTap: () {
                              Navigator.pop(context, ocean);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ocean.name,
                                    style: TextStyle(
                                      fontWeight: ocean.id == _currentOcean?.id ? FontWeight.bold : FontWeight.normal,
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${ocean.bottleCount}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            onSelected: (Ocean ocean) {
              setState(() {
                _currentOcean = ocean;
                _loadBottles(ocean.id);
              });
            },
          ),
        ],
      ),
    );
  }

  // 修改漂流瓶展示部分
  Widget _buildBottlesArea() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_bottles.isEmpty) {
      return const Center(
        child: Text(
          '这片海域还没有漂流瓶...',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Expanded(
      child: Stack(
        children: _bottles.asMap().entries.map((entry) {
          final index = entry.key;
          final bottle = entry.value;
          // 使用固定的位置或根据索引计算位置
          final position = Offset(
            0.2 + (index % 3) * 0.3,
            0.3 + (index ~/ 3) * 0.2,
          );

          return Positioned(
            left: MediaQuery.of(context).size.width * position.dx,
            top: MediaQuery.of(context).size.height * position.dy,
            child: Transform.rotate(
              angle: (index % 4 - 1.5) * 0.3,
              child: Transform.translate(
                offset: Offset(
                  0,
                  10 * sin(DateTime.now().millisecondsSinceEpoch / 1000),
                ),
                child: GestureDetector(
                  onTap: () => _showBottleDialog(bottle),
                  child: Image.network(
                    'https://fkxs-1321402197.cos.ap-guangzhou.myqcloud.com/bottle_cloth%2Fbottle1.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.wine_bar,
                          color: Colors.blue[300],
                          size: 32,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showBottleDialog(BottleModel bottle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          '来自${_currentOcean?.name}的漂流瓶',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('确认要打开该漂流瓶吗？'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _openBottle(bottle);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('确认'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openBottle(BottleModel bottle) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: SizedBox(
          width: 200,
          height: 200,
          child: Lottie.asset(
            'assets/animations/lottie_bottle_open.json',
            repeat: false,
            onLoaded: (composition) {
              Future.delayed(composition.duration, () {
                Navigator.pop(context);
                Get.to(
                  () => BottleCardDetail(
                    id: bottle.id,
                    title: bottle.title,
                    content: bottle.content,
                    imageUrl: bottle.imageUrl,
                    audioUrl: bottle.audioUrl,
                    createdAt: bottle.createdAt,
                    user: bottle.user,
                    mood: bottle.mood,
                    isFavorited: bottle.isFavorited,
                    isResonated: bottle.isResonated,
                    views: bottle.views,
                    shares: bottle.shares,
                    favorites: bottle.favorites,
                    resonates: bottle.resonates,
                  ),
                );
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景图片
          if (_currentOcean != null)
            Image.network(
              _currentOcean!.bg,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.blue[300],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.blue[300],
                  child: const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                );
              },
            ),

          // 波浪动画效果
          Positioned.fill(
            child: CustomPaint(
              painter: WavePainter(),
            ),
          ),

          // 主要内容
          SafeArea(
            child: Column(
              children: [
                _buildOceanHeader(),
                _buildBottlesArea(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 波浪动画效果
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.7);

    // 创建波浪效果
    for (double i = 0; i <= size.width; i++) {
      path.lineTo(
        i,
        size.height * 0.7 + sin(i / 30) * 10,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
