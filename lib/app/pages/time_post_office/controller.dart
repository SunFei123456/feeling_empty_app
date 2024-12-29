import 'package:get/get.dart';

class TimePostOfficeController extends GetxController {
  final RxList posts = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  void loadPosts() {
    posts.value = [
  //       final String title;
  // final String author;
  // final String? imageUrl;
  // final String content;
  // final String letterContent;
  // final bool isLocked;
  // final String unlockTime;
  // final String type;
  // final String category;
  // final String createdAt;
  // final bool isTop;

      {
        'title': '今天的心情',
        'author': '小明',
        'content': '今天天气真好，心情也很愉快！希望每个人都能开开心心的。',
        'letterContent': '这是信封里面的内容',
        'type': '心情',
        'category': '生活',
        'isLocked': true,
        'unlockTime': '2024.06.01',
        'createdAt': '2024.01.20',
      },
      {
        'title': '美好的下午',
        'author': '小红',
        'imageUrl': 'https://picsum.photos/200/300',
        'content': '下午和朋友一起喝咖啡，聊了很多有趣的事情。',
        'letterContent': '这是信封里面的内容',
        'type': '照片',
        'category': '友情',
        'isLocked': false,
        'unlockTime': '2024.01.20',
        'createdAt': '2024.01.19',
      },
      {
        'title': '美好的下午',
        'author': '小红',
        'imageUrl': 'https://picsum.photos/200/300',
        'content': '下午和朋友一起喝咖啡，聊了很多有趣的事情。',
        'letterContent': '这是信封里面的内容',
        'likes': 25,
        'type': '图片',
        'isLocked': true,
        'unlockTime': '2024.01.20',
      },
      {
        'title': '分享一首歌',
        'author': '小华',
        'content': '最近很喜欢这首歌，单曲循环中...',
        'letterContent': '这是信封里面的内容',
        'likes': 18,
        'type': '文字',
        'isLocked': true,
        'unlockTime': '2024.06.01',
      },
      {
        'title': '分享一首歌',
        'author': '小华',
        'content': '最近很喜欢这首歌，单曲循环中...',
        'letterContent': '这是信封里面的内容',
        'likes': 18,
        'type': '文字',
        'isLocked': true,
        'unlockTime': '2024.06.01',
      },
      {
        'title': '分享一首歌',
        'author': '小华',
        'content': '最近很喜欢这首歌，单曲循环中...',
        'letterContent': '这是信封里面的内容',
        'likes': 18,
        'type': '文字',
        'isLocked': true,
        'unlockTime': '2024.06.01',
      },
      {
        'title': '分享一首歌',
        'author': '小华',
        'content': '最近很喜欢这首歌，单曲循环中...',
        'letterContent': '这是信封里面的内容',
        'likes': 18,
        'type': '文字',
        'isLocked': true,
        'unlockTime': '2024.06.01',
      },
      {
        'title': '分享一首歌',
        'author': '小华',
        'content': '最近很喜欢这首歌，单曲循环中...',
        'letterContent': '这是信封里面的内容',
        'likes': 18,
        'type': '文字',
        'isLocked': true,
        'unlockTime': '2024.06.01',
      },
      {
        'title': '分享一首歌',
        'author': '小华',
        'content': '最近很喜欢这首歌，单曲循环中...',
        'letterContent': '这是信封里面的内容',
        'likes': 18,
        'type': '文字',
        'isLocked': true,
        'unlockTime': '2024.06.01',
      },
      {
        'title': '分享一首歌',
        'author': '小华',
        'content': '最近很喜欢这首歌，单曲循环中...',
        'letterContent': '这是信封里面的内容',
        'likes': 18,
        'type': '文字',
        'isLocked': true,
        'unlockTime': '2024.06.01',
      },
    ];
  }
}
