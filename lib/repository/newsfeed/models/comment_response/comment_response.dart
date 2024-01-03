import 'package:json_annotation/json_annotation.dart';

part 'comment_response.g.dart';

@JsonSerializable()
class CommentResponse {
  String? id;
  String? newsfeedId;
  String? createdBy;
  String? content;
  DateTime? createdTime;
  String? userProfileName;

  CommentResponse({
    this.id,
    this.newsfeedId,
    this.createdBy,
    this.content,
    this.createdTime,
    this.userProfileName,
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return _$CommentResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CommentResponseToJson(this);

  static List<CommentResponse> fromJsonArray(
    List<dynamic> jsonArray,
  ) {
    return jsonArray
        .map(
          (dynamic e) => CommentResponse.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
