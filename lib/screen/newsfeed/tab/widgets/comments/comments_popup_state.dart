import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:fitness_app/repository/newsfeed/models/comment_response/comment_response.dart';

part 'comments_popup_state.g.dart';

@CopyWith()
class CommentsPopupState {
  final int id;
  final int userId;
  final String userName;
  final List<CommentResponse>? dataList;
  final bool isLoading;

  const CommentsPopupState({
    this.id = 0,
    this.userId = 0,
    this.userName = '',
    this.dataList,
    this.isLoading = false,
  });
}
