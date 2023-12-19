import 'package:fitness_app/api/services/nutritions/nutritions_service.dart';
import 'package:flutter/foundation.dart';

import 'models/nutrition_response/nutrition_response.dart';

class NutritionsRepository {
  final _service = NutritionsService();

  Future<NutritionResponse> getNutritionById({
    required String id,
  }) async {
    try {
      final response = await _service.getNutritionById(
        id: id,
      );
      if (response.statusCode == 200) {
        final result = NutritionResponse.fromJson(response.data);
        return result;
      } else {
        return NutritionResponse();
      }
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
      return NutritionResponse();
    }
  }
}
