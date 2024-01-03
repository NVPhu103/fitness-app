import 'package:dio/dio.dart';
import 'package:fitness_app/api/exception/api_endpoints.dart';
import 'package:fitness_app/base/base_service.dart';

import 'models/create_comment_request.dart';
import 'models/create_newsfeed_request.dart';

class NewsfeedService extends BaseService {
  Future<Response> searchLocation({
    required String location,
  }) async {
    final response = await get(
      NewsfeedApi.searchLocation.replaceAll(RegExp('{location}'), location),
    );
    return response;
  }

  Future<Response> createNewsfeed({
    required CreateNewsfeedRequest request,
  }) async {
    final response = await post(
      NewsfeedApi.newsfeed,
      data: request.toJson(),
    );
    return response;
  }

  Future<Response> filterNewsfeed({
    String? createdBy,
    String? exerciseName,
    String? locationId,
    required String page,
  }) async {
    String path = '${NewsfeedApi.newsfeed}?page={page}&per_page=10';
    if (createdBy != null) {
      path =
          '${NewsfeedApi.newsfeed}?q=createdBy:$createdBy&page={page}&per_page=10';
    } else if (exerciseName != null && locationId != null) {
      path =
          '${NewsfeedApi.newsfeed}?q=exerciseName:$exerciseName%2Blocation_id:$locationId&page={page}&per_page=10';
    } else if (exerciseName != null) {
      path =
          '${NewsfeedApi.newsfeed}?q=exerciseName:$exerciseName&page={page}&per_page=10';
    } else if (locationId != null) {
      path =
          '${NewsfeedApi.newsfeed}?q=location_id:$locationId&page={page}&per_page=10';
    }

    final response = await get(
      path.replaceAll(RegExp('{page}'), page),
    );
    return response;
  }

  Future<Response> createComment({
    required CreateCommentRequest request,
  }) async {
    final response = await post(
      NewsfeedApi.createComment,
      data: request.toJson(),
    );
    return response;
  }

  Future<Response> filterComments({
    required String id,
    required String page,
  }) async {
    final response = await get(
      NewsfeedApi.filterComments
          .replaceAll(RegExp('{id}'), id)
          .replaceAll(RegExp('{page}'), page),
    );
    return response;
  }

  Future<Response> deleteComment({
    required String id,
    required String idCom,
  }) async {
    final response = await delete(
      NewsfeedApi.deleteComment
          .replaceAll(RegExp('{id}'), id)
          .replaceAll(RegExp('{idCom}'), idCom),
    );
    return response;
  }
}
