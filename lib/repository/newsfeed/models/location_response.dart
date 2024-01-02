import 'package:json_annotation/json_annotation.dart';

part 'location_response.g.dart';

@JsonSerializable()
class LocationResponse {
  String? id;
  String? location;

  LocationResponse({
    this.id,
    this.location,
  });

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return _$LocationResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LocationResponseToJson(this);

  static List<LocationResponse> fromJsonArray(
    List<dynamic> jsonArray,
  ) {
    return jsonArray
        .map(
          (dynamic e) =>
              LocationResponse.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
