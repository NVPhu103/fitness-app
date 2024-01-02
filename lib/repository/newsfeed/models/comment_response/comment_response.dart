import 'package:json_annotation/json_annotation.dart';

part 'comment_response.g.dart';

@JsonSerializable()
class CommentResponse {
  int? commentId;
  int? postId;
  int? userId;
  String? content;
  DateTime? commentDate;
  String? fullName;

  CommentResponse({
    this.commentId,
    this.postId,
    this.userId,
    this.content,
    this.commentDate,
    this.fullName,
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
