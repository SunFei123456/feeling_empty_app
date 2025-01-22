import 'package:event_bus/event_bus.dart';
import 'package:get/get.dart';

class EventBusService extends GetxService {
  final eventBus = EventBus();

  static EventBusService get to => Get.find<EventBusService>();
} 