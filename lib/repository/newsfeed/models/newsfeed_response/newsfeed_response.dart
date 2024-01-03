import 'package:fitness_app/repository/newsfeed/models/location_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'newsfeed_response.g.dart';

@JsonSerializable()
class NewsfeedResponse {
  String? id;
  DateTime? exerciseTime;
  String? exerciseName;
  LocationResponse? location;
  String? content;
  String? createdBy;
  DateTime? createdTime;
  String? userProfileName;

  NewsfeedResponse({
    this.id,
    this.exerciseTime,
    this.exerciseName,
    this.location,
    this.content,
    this.createdBy,
    this.createdTime,
    this.userProfileName,
  });

  factory NewsfeedResponse.fromJson(Map<String, dynamic> json) {
    return _$NewsfeedResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$NewsfeedResponseToJson(this);

  static List<NewsfeedResponse> fromJsonArray(
    List<dynamic> jsonArray,
  ) {
    return jsonArray
        .map(
          (dynamic e) => NewsfeedResponse.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
