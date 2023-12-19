import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nutrition_response.g.dart';

@JsonSerializable()
@CopyWith()
class NutritionResponse {
  @JsonKey(name: 'food_id')
  String? foodId;
  num? calories;
  num? protein;
  num? totalFat;
  num? cholesterol;
  num? carbohydrate;
  num? sugars;
  num? dietaryFiber;
  num? vitaminA;
  num? vitaminB1;
  num? vitaminB2;
  num? vitaminB6;
  num? vitaminB9;
  num? vitaminB12;
  num? vitaminC;
  num? vitaminD;
  num? vitaminE;
  num? vitaminK;
  num? canxi;
  num? phospho;
  num? fe;
  num? magie;
  num? zn;
  num? natri;
  num? iod;
  num? omega3;
  num? omega6;
  num? omega9;

  NutritionResponse({
    this.foodId,
    this.calories,
    this.protein,
    this.totalFat,
    this.cholesterol,
    this.carbohydrate,
    this.sugars,
    this.dietaryFiber,
    this.vitaminA,
    this.vitaminB1,
    this.vitaminB2,
    this.vitaminB6,
    this.vitaminB9,
    this.vitaminB12,
    this.vitaminC,
    this.vitaminD,
    this.vitaminE,
    this.vitaminK,
    this.canxi,
    this.phospho,
    this.fe,
    this.magie,
    this.zn,
    this.natri,
    this.iod,
    this.omega3,
    this.omega6,
    this.omega9,
  });

  factory NutritionResponse.fromJson(Map<String, dynamic> json) {
    return _$NutritionResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$NutritionResponseToJson(this);
}
