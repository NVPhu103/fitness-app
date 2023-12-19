import 'package:json_annotation/json_annotation.dart';

part 'food_diary_request.g.dart';

@JsonSerializable()
class FoodDiaryRequest {
  String? mealId;
  String? foodId;
  String? quantity;

  FoodDiaryRequest({
    this.mealId,
    this.foodId,
    this.quantity,
  });

  factory FoodDiaryRequest.fromJson(Map<String, dynamic> json) {
    return _$FoodDiaryRequestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FoodDiaryRequestToJson(this);
}
