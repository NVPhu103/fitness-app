import 'package:json_annotation/json_annotation.dart';

part 'create_newsfeed_request.g.dart';

@JsonSerializable()
class CreateNewsfeedRequest {
  DateTime? exerciseTime;
  String? exerciseName;
  String? locationId;
  String content;
  String createdBy;

  CreateNewsfeedRequest({
    this.exerciseTime,
    this.exerciseName,
    this.locationId,
    required this.content,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() => _$CreateNewsfeedRequestToJson(this);
}
