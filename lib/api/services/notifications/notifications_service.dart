import 'package:dio/dio.dart';
import 'package:fitness_app/api/exception/api_endpoints.dart';
import 'package:fitness_app/base/base_service.dart';

class NotificationsService extends BaseService {
  Future<Response> getUnreadNotification({
    required String id,
  }) async {
    final response = await get(
      NotificationsApi.getUnreadNotification.replaceAll(RegExp('{id}'), id),
    );
    return response;
  }

  Future<Response> resetUnreadNotification({
    required String id,
  }) async {
    final response = await patch(
      NotificationsApi.resetUnreadNotification.replaceAll(RegExp('{id}'), id),
    );
    return response;
  }

  Future<Response> filterNotifications({
    required String id,
    required String page,
  }) async {
    final response = await get(
      NotificationsApi.filterNotifications
          .replaceAll(RegExp('{id}'), id)
          .replaceAll(RegExp('{page}'), page),
    );
    return response;
  }

  Future<Response> getDiaryNotifications({
    required String url,
  }) async {
    final response = await get(url);
    return response;
  }

  Future<Response> getSuggesstionNotifications({
    required String url,
  }) async {
    final response = await get(url);
    return response;
  }
}
