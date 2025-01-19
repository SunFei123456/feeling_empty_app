import 'package:flutter/material.dart';

Widget buildMoodChip(String? mood) {
  // 定义心情对应的图标
  final moodIcons = {
    '开心': '😊',
    '伤心': '😢',
    '愤怒': '😠',
    '平静': '😌',
    '焦虑': '😰',
    '兴奋': '🤩',
    '疲惫': '😫',
    '困惑': '🤔',
    '害怕': '😨',
    '惊讶': '😲',
    '无聊': '😑',
    '孤独': '🥺',
    '感激': '🙏',
    '期待': '🤗',
    'happy': '😊',
    'sad': '😢',
    'angry': '😠',
    'calm': '😌',
    'anxious': '😰',
    'excited': '🤩',
    'tired': '😫',
    'confused': '🤔',
    'scared': '😨',
    'surprised': '😲',
    'bored': '😑',
    'lonely': '🥺',
    'grateful': '🙏',
    'hopeful': '🤗',
  };

  final emoji = moodIcons[mood] ?? '😶'; // 如果没有匹配的心情，使用默认表情

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.1),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(emoji, style: const TextStyle(fontSize: 12)),
  );
}
