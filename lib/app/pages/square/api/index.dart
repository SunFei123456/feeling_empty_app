import 'package:fangkong_xinsheng/app/core/http/api_response.dart';
import 'package:fangkong_xinsheng/app/core/services/api_service.dart';
import 'package:fangkong_xinsheng/app/pages/bottle/model/bottle_model.dart';
class SquareApiService extends BaseApiService {
  // 获取随机漂流瓶
  Future<ApiResponse<List<BottleModel>>> getRandomBottles() async {
    try {
      final response = await BaseApiService.dio.get('/bottles/random');

      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => (json as List)
            .map((item) => BottleModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      print('Get random bottles error: $e');
      rethrow;
    }
  }
}
