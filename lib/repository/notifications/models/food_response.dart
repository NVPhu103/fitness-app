import 'package:json_annotation/json_annotation.dart';

part 'food_response.g.dart';

@JsonSerializable()
class FoodResponse {
  String? name;
  int? calories;
  String? unit;
  String? id;
  String? status;

  FoodResponse({this.name, this.calories, this.unit, this.id, this.status});

  factory FoodResponse.fromJson(Map<String, dynamic> json) {
    return _$FoodResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FoodResponseToJson(this);

  static List<FoodResponse> fromJsonArray(
    List<dynamic> jsonArray,
  ) {
    return jsonArray
        .map(
          (dynamic e) => FoodResponse.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
