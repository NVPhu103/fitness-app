import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:fitness_app/repository/notifications/models/notification_response.dart';
import 'package:fitness_app/screen/diary/components/diary.dart';

part 'notification_state.g.dart';

@CopyWith()
class NotificationState {
  final String id;
  final List<NotificationResponse>? dataList;
  final int currentPage;
  final bool canLoadMore;
  final bool isTapDiary;
  final Diary? diary;

  const NotificationState({
    this.id = '',
    this.dataList,
    this.currentPage = 1,
    this.canLoadMore = false,
    this.isTapDiary = false,
    this.diary,
  });
}
