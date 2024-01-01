import 'package:fitness_app/api/services/nutritions/nutritions_service.dart';
import 'package:fitness_app/utilities/date_time.dart';
import 'package:flutter/foundation.dart';

import 'models/dailynutrition_response/dailynutrition_response.dart';
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

  Future<DailynutritionResponse> getDailynutritionById({
    required String id,
  }) async {
    try {
      final response = await _service.getDailynutritionById(
        id: id,
      );
      if (response.statusCode == 200) {
        final result = DailynutritionResponse.fromJson(response.data);
        return result;
      } else {
        return DailynutritionResponse();
      }
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
      return DailynutritionResponse();
    }
  }

  Future<DailynutritionResponse> getDailynutritionTotalById({
    required String id,
    required DateTime startDate,
    DateTime? endDate,
    required String type,
  }) async {
    try {
      final response = await _service.getDailynutritionTotalById(
        id: id,
        startDate: startDate.format(pattern: yyyy_mm_dd),
        endDate: endDate?.format(pattern: yyyy_mm_dd) ??
            startDate.format(pattern: yyyy_mm_dd),
        type: type,
      );
      if (response.statusCode == 200) {
        final result = DailynutritionResponse.fromJson(response.data);
        return result;
      } else {
        return DailynutritionResponse();
      }
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
      return DailynutritionResponse();
    }
  }
}
