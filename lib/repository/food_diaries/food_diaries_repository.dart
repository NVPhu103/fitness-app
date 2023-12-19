import 'package:fitness_app/api/services/food_diaries/food_diaries_service.dart';
import 'package:fitness_app/api/services/food_diaries/models/food_diary_request.dart';
import 'package:flutter/foundation.dart';

import 'models/food_diary_response.dart';

class FoodDiariesRepository {
  final _service = FoodDiariesService();

  Future<FoodDiaryResponse?> creatFoodDiary({
    required FoodDiaryRequest request,
  }) async {
    try {
      final response = await _service.creatFoodDiary(
        request: request,
      );
      final result = FoodDiaryResponse.fromJson(response.data);
      return result;
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
      return null;
    }
  }

  Future<FoodDiaryResponse?> updateFoodDiary({
    required FoodDiaryRequest request,
  }) async {
    try {
      final response = await _service.updateFoodDiary(
        request: request,
      );
      final result = FoodDiaryResponse.fromJson(response.data);
      return result;
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
      return null;
    }
  }
}
