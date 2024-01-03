import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:fitness_app/repository/newsfeed/models/location_response.dart';
import 'package:fitness_app/repository/newsfeed/models/newsfeed_response/newsfeed_response.dart';

part 'newsfeed_tab_state.g.dart';

@CopyWith()
class NewsfeedTabState {
  final int currentTab;
  final String id;
  final bool isLoading;
  final List<NewsfeedResponse>? dataList;
  final int currentPage;
  final bool canLoadMore;
  final String? exerciseName;
  final LocationResponse? location;

  const NewsfeedTabState({
    this.currentTab = 0,
    this.id = '',
    this.isLoading = false,
    this.dataList,
    this.currentPage = 1,
    this.canLoadMore = false,
    this.exerciseName,
    this.location,
  });
}
