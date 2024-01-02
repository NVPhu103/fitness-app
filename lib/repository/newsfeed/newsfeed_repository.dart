import 'package:fitness_app/api/services/newsfeed/models/create_newsfeed_request.dart';
import 'package:fitness_app/api/services/newsfeed/newsfeed_service.dart';
import 'package:flutter/foundation.dart';

import 'models/filter_newsfeed_response.dart';
import 'models/location_response.dart';
import 'models/newsfeed_response/newsfeed_response.dart';

class NewsfeedRepository {
  final _service = NewsfeedService();

  Future<FilterNewsfeedResponse> filterNewsfeed({
    String? createdBy,
    String? exerciseName,
    String? locationId,
    required int page,
  }) async {
    try {
      final response = await _service.filterNewsfeed(
        createdBy: createdBy,
        exerciseName: exerciseName,
        locationId: locationId,
        page: page.toString()
      );
      if (response.statusCode == 200) {
        final totalPages = response.headers['total-record'];
        final data = NewsfeedResponse.fromJsonArray(response.data);
        return FilterNewsfeedResponse(
          totalPages: totalPages != null ? int.parse(totalPages[0]) : 0,
          data: data,
        );
      } else {
        return FilterNewsfeedResponse();
      }
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
      return FilterNewsfeedResponse();
    }
  }

  Future<void> createNewsfeed({
    required CreateNewsfeedRequest request,
  }) async {
    try {
      await _service.createNewsfeed(
        request: request,
      );
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
    }
  }

  Future<List<LocationResponse>> searchLocation({
    required String location,
  }) async {
    try {
      final response = await _service.searchLocation(
        location: location,
      );
      if (response.statusCode == 200) {
        final result = LocationResponse.fromJsonArray(response.data);
        return result;
      } else {
        return [];
      }
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
      return [];
    }
  }
}
