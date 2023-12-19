import 'package:fitness_app/api/services/food_diaries/food_diaries_service.dart';
import 'package:fitness_app/api/services/food_diaries/models/food_diary_request.dart';
import 'package:flutter/foundation.dart';

class FoodDiariesRepository {
  final _service = FoodDiariesService();

  Future<void> creatFoodDiary({
    required FoodDiaryRequest request,
  }) async {
    try {
      await _service.creatFoodDiary(
        request: request,
      );
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
    }
  }

  Future<void> updateFoodDiary({
    required FoodDiaryRequest request,
  }) async {
    try {
      await _service.updateFoodDiary(
        request: request,
      );
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
    }
  }
}
