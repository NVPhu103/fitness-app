import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:fitness_app/repository/nutritions/models/nutrition_response/nutrition_response.dart';

part 'detail_food_state.g.dart';

@CopyWith()
class DetailFoodState {
  final bool isLoading;
  final NutritionResponse? data;
  final String mealId;
  final String foodId;
  final String foodName;
  final String unit;
  final num quantity;
  final bool isSuccess;

  const DetailFoodState({
    this.isLoading = false,
    this.data,
    this.mealId = '',
    this.foodId = '',
    this.foodName = '',
    this.unit = '',
    this.quantity = 0,
    this.isSuccess = false,
  });
}
