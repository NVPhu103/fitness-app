import 'package:dio/dio.dart';
import 'package:fitness_app/api/exception/api_endpoints.dart';
import 'package:fitness_app/base/base_service.dart';

class NutritionsService extends BaseService {
  Future<Response> getNutritionById({
    required String id,
  }) async {
    final response = await get(
      NutritionsApi.nutritionById.replaceAll(RegExp('{id}'), id),
    );
    return response;
  }

  Future<Response> getDailynutritionById({
    required String id,
  }) async {
    final response = await get(
      NutritionsApi.dailynutritionById.replaceAll(RegExp('{id}'), id),
    );
    return response;
  }

  Future<Response> getDailynutritionTotalById({
    required String id,
    required String startDate,
    required String endDate,
    required String type,
  }) async {
    final response = await get(
      NutritionsApi.dailynutritionTotalById
          .replaceAll(RegExp('{id}'), id)
          .replaceAll(RegExp('{startDate}'), startDate)
          .replaceAll(RegExp('{endDate}'), endDate)
          .replaceAll(RegExp('{type}'), type),
    );
    return response;
  }
}
