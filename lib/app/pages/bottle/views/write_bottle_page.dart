import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WriteBottlePage extends StatelessWidget {
  const WriteBottlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('写漂流瓶'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('漂流瓶编写页面'),
      ),
    );
  }
} 