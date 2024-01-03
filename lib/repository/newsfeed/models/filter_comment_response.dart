import 'comment_response/comment_response.dart';

class FilterCommentResponse {
  int? totalPages;
  List<CommentResponse>? data;

  FilterCommentResponse({
    this.totalPages,
    this.data,
  });
}
