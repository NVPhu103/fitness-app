import 'package:json_annotation/json_annotation.dart';

part 'create_comment_request.g.dart';

@JsonSerializable()
class CreateCommentRequest {
  String newsfeedId;
  String content;
  String createdBy;

  CreateCommentRequest({
    required this.newsfeedId,
    required this.content,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() => _$CreateCommentRequestToJson(this);
}
