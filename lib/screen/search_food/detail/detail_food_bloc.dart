import 'package:fitness_app/api/services/food_diaries/models/food_diary_request.dart';
import 'package:fitness_app/repository/food_diaries/food_diaries_repository.dart';
import 'package:fitness_app/repository/nutritions/nutritions_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'detail_food_state.dart';

class DetailFoodBloc extends Cubit<DetailFoodState> {
  final FoodDiariesRepository _foodDiariesRepository = FoodDiariesRepository();
  final NutritionsRepository _nutritionsRepository = NutritionsRepository();
  DetailFoodBloc() : super(const DetailFoodState());

  getData({
    required String mealId,
    required String foodId,
    required String foodName,
    required String unit,
    required num quantity,
  }) async {
    try {
      emit(
        state.copyWith(isLoading: true),
      );
      final data = await _nutritionsRepository.getNutritionById(
        id: foodId,
      );

      emit(state.copyWith(
        mealId: mealId,
        foodId: foodId,
        unit: unit,
        quantity: quantity,
        data: data,
        isLoading: false,
      ));
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
    }
  }

  onSubmit({
    required bool isUpdate,
    required String quantity,
  }) async {
    try {
      emit(state.copyWith(isSuccess: false));

      if (isUpdate) {
        await _foodDiariesRepository.updateFoodDiary(
          request: FoodDiaryRequest(
            mealId: state.mealId,
            foodId: state.foodId,
            quantity: quantity,
          ),
        );
      } else {
        await _foodDiariesRepository.creatFoodDiary(
          request: FoodDiaryRequest(
            mealId: state.mealId,
            foodId: state.foodId,
            quantity: quantity,
          ),
        );
      }

      emit(state.copyWith(isSuccess: true, quantity: num.tryParse(quantity)));
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
    }
  }
}
