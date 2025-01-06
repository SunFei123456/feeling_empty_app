import 'package:fangkong_xinsheng/app/core/http/api_response.dart';
import 'package:fangkong_xinsheng/app/core/services/api_service.dart';
import 'package:fangkong_xinsheng/app/pages/views/model/ocean.dart';
import 'package:fangkong_xinsheng/app/pages/square/model/bottle_card.dart';

class OceanApiService extends BaseApiService {
  // 获取所有海域
  Future<ApiResponse<List<Ocean>>> getOceans() async {
    try {
      final response = await BaseApiService.dio.get('/oceans');
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['data'] != null) {
        return ApiResponse<List<Ocean>>(
          code: responseData['code'] as int,
          message: responseData['message'] as String,
          data: (responseData['data'] as List)
              .map((item) => Ocean.fromJson(item as Map<String, dynamic>))
              .toList(),
          success: responseData['code'] == 200,
        );
      }
      return ApiResponse<List<Ocean>>(
        code: responseData['code'] as int,
        message: responseData['message'] as String,
        data: [],
        success: false,
      );
    } catch (e) {
      print('Get oceans error: $e');
      rethrow;
    }
  }

  // 获取指定海域下的漂流瓶
  Future<ApiResponse<List<BottleCardModel>>> getBottlesByOceanId(int oceanId) async {
    try {
      final response = await BaseApiService.dio.get('/oceans/$oceanId/bottles');
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['data'] != null) {
        return ApiResponse<List<BottleCardModel>>(
          code: responseData['code'] as int,
          message: responseData['message'] as String,
          data: (responseData['data'] as List)
              .map((item) => BottleCardModel.fromJson(item as Map<String, dynamic>))
              .toList(),
          success: responseData['code'] == 200,
        );
      }
      return ApiResponse<List<BottleCardModel>>(
        code: responseData['code'] as int,
        message: responseData['message'] as String,
        data: [],
        success: false,
      );
    } catch (e) {
      print('Get bottles by ocean error: $e');
      rethrow;
    }
  }
}

