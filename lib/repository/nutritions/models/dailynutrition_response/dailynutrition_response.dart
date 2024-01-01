import 'package:json_annotation/json_annotation.dart';

part 'dailynutrition_response.g.dart';

@JsonSerializable()
class DailynutritionResponse {
  @JsonKey(name: 'user_profile_id')
  String? userProfileId;
  String? userId;
  num? protein;
  num? totalFat;
  num? cholesterol;
  num? carbohydrate;
  num? sugars;
  num? dietaryFiber;
  num? vitaminA;
  num? vitaminC;
  num? canxi;
  num? natri;
  num? kali;
  num? iod;

  DailynutritionResponse({
    this.userProfileId,
    this.userId,
    this.protein,
    this.totalFat,
    this.cholesterol,
    this.carbohydrate,
    this.sugars,
    this.dietaryFiber,
    this.vitaminA,
    this.vitaminC,
    this.canxi,
    this.natri,
    this.kali,
    this.iod,
  });

  factory DailynutritionResponse.fromJson(Map<String, dynamic> json) {
    return _$DailynutritionResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DailynutritionResponseToJson(this);
}
