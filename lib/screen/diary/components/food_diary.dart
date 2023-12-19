import 'package:copy_with_extension/copy_with_extension.dart';
part 'food_diary.g.dart';
class Food {
  late String id;
  late String name;
  late int calories;
  late String unit;
  late String status;

  Food(this.id, this.name, this.calories, this.unit, this.status);

  Food.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    calories = json['calories'];
    unit = json['unit'];
    status = json['status'];
  }
}

@CopyWith()
class FoodDiary {
  late String id;
  late String mealId;
  late String foodId;
  late num quantity;
  late int totalCalories;
  late Food food;

  FoodDiary(this.id, this.mealId, this.foodId, this.quantity,
      this.totalCalories, this.food);

  FoodDiary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mealId = json['mealId'];
    foodId = json['foodId'];
    quantity = json['quantity'];
    totalCalories = json['totalCalories'];
    food = Food.fromJson(json['food']);
  }
}
