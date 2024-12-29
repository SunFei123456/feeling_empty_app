import 'dart:io';
import 'package:image/image.dart' as img;

void convertJpgToPng() {
  // 读取 JPG 文件
  final jpgImage = File('assets/icon/app_icon.jpg').readAsBytesSync();
  final image = img.decodeImage(jpgImage);

  if (image != null) {
    // 编码为 PNG
    final pngBytes = img.encodePng(image);
    
    // 保存 PNG 文件
    File('assets/icon/app_icon.png').writeAsBytesSync(pngBytes);
  }
} 