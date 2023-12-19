import 'package:dio/dio.dart';
import 'package:fitness_app/api/exception/api_endpoints.dart';
import 'package:fitness_app/base/base_service.dart';

import 'models/food_diary_request.dart';

class FoodDiariesService extends BaseService {
  Future<Response> creatFoodDiary({
    required FoodDiaryRequest request,
  }) async {
    final response = await post(
      FoodDiariesApi.fooddiaries,
      data: request.toJson(),
    );
    return response;
  }

  Future<Response> updateFoodDiary({
    required FoodDiaryRequest request,
  }) async {
    final response = await patch(
      FoodDiariesApi.fooddiaries,
      data: request.toJson(),
    );
    return response;
  }
}
