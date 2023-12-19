import 'package:fitness_app/screen/diary/components/diary.dart';

class FoodDiaryResponse {
  late String id;
  late String mealId;
  late String foodId;
  late num quantity;
  late num totalCalories;
  late Diary diary;

  FoodDiaryResponse(
    this.id,
    this.mealId,
    this.foodId,
    this.quantity,
    this.totalCalories,
    this.diary,
  );

  FoodDiaryResponse.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    mealId = json["mealId"];
    foodId = json["foodId"];
    quantity = json["quantity"];
    totalCalories = json["totalCalories"];
    diary = Diary.fromJson(json["diary"]);
  }
}
