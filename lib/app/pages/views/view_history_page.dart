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
        title: Text(
          'browsing_history'.tr,
          style: const TextStyle(
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
                title: 'delete_confirm',
                content: 'delete_all_history',
                confirmText: 'confirm',
                cancelText: 'cancel',
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
          return const Center(child: CircularProgressIndicator());
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
                  BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, 1), blurRadius: 2),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.history_rounded, color: Theme.of(context).primaryColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '共 ${controller.totalItems} 条记录',
                    style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500),
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
                  itemCount: controller.historyItems.length + (controller.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.historyItems.length - 3 && controller.hasMore) {
                      Future.microtask(() => controller.loadViewHistory());
                    }

                    if (index == controller.historyItems.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return Dismissible(
                      key: Key(controller.historyItems[index].id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.redAccent,
                        child: const Icon(Icons.delete_outline, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('delete_confirm'.tr),
                              content: Text('delete_one_history'.tr),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text('cancel'.tr),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: Text(
                                    'delete'.tr,
                                    style: const TextStyle(color: Colors.red),
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
