import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fangkong_xinsheng/app/pages/views/controller/view_history_controller.dart';
import 'package:fangkong_xinsheng/app/widgets/common_bottle_card.dart';
import 'package:fangkong_xinsheng/app/widgets/confirm_dialog.dart';

class ViewHistoryPage extends GetView<ViewHistoryController> {
  ViewHistoryPage() {
    Get.put(ViewHistoryController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '浏览记录',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline_rounded),
            onPressed: () => {
              ConfirmDialog.show(
                title: '删除确认',
                content: '确定要删除所有浏览记录吗？',
                confirmText: '确认',
                cancelText: '取消',
                onConfirm: () {
                  Get.find<ViewHistoryController>().clearHistory();
                },
              ),
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.historyItems.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.historyItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_rounded, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  '暂无浏览记录',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '共 ${controller.totalItems} 条记录',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.loadViewHistory(refresh: true),
                color: Theme.of(context).primaryColor,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: controller.historyItems.length,
                  itemBuilder: (context, index) {
                    if (index == controller.historyItems.length - 1) {
                      controller.loadViewHistory();
                    }
                    return Dismissible(
                      key: Key(controller.historyItems[index].id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('确认删除'),
                              content: const Text('确定要删除这条浏览记录吗？'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('取消'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text(
                                    '删除',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        controller.deleteViewHistory(
                          controller.historyItems[index].id,
                        );
                      },
                      child: CommonBottleCard(
                        bottle: controller.historyItems[index],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
