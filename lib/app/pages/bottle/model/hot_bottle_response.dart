import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
class HotBottlesResponse {
  final List<BottleModel> bottles;
  final String timeRange;
  final int total;
  final int page;
  final int size;

  HotBottlesResponse({
    required this.bottles,
    required this.timeRange,
    required this.total,
    required this.page,
    required this.size,
  });

  factory HotBottlesResponse.fromJson(Map<String, dynamic> json) {
    print('Parsing HotBottlesResponse: $json');
    return HotBottlesResponse(
      bottles: (json['bottles'] as List?)?.map((item) {
            print('Parsing bottle item: $item');
            return BottleModel.fromJson(item as Map<String, dynamic>);
          }).toList() ??
          [],
      timeRange: json['time_range'] as String? ?? 'week',
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      size: json['size'] as int? ?? 10,
    );
  }
}
