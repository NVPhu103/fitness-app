import 'newsfeed_response/newsfeed_response.dart';

class FilterNewsfeedResponse {
  int? totalPages;
  List<NewsfeedResponse>? data;

  FilterNewsfeedResponse({
    this.totalPages,
    this.data,
  });
}
