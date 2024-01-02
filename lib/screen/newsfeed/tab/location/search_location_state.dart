import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:fitness_app/repository/newsfeed/models/location_response.dart';

part 'search_location_state.g.dart';

@CopyWith()
class SearchLocationState {
  final bool isLoading;
  final List<LocationResponse>? dataList;

  const SearchLocationState({
    this.isLoading = false,
    this.dataList,
  });
}
