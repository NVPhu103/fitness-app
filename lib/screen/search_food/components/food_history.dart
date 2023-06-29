import 'package:fitness_app/screen/diary/components/food_diary.dart';

class FoodHistory {
  late String id;
  late String userId;
  late String foodId;
  late int numberOfUses;
  late Food food;

  FoodHistory(this.id, this.userId, this.foodId, this.numberOfUses, this.food);

  FoodHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    foodId = json['foodId'];
    numberOfUses = json['numberOfUses'];
    food = Food.fromJson(json['food']);
  }
}
