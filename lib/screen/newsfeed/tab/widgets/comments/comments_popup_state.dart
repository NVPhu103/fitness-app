import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:fitness_app/repository/newsfeed/models/comment_response/comment_response.dart';

part 'comments_popup_state.g.dart';

@CopyWith()
class CommentsPopupState {
  final String id;
  final String userId;
  final List<CommentResponse>? dataList;
  final bool isLoading;
  final int currentPage;
  final bool canLoadMore;
  final bool onReload;

  const CommentsPopupState({
    this.id = '',
    this.userId = '',
    this.dataList,
    this.isLoading = false,
    this.currentPage = 1,
    this.canLoadMore = false,
    this.onReload = false,
  });
}
