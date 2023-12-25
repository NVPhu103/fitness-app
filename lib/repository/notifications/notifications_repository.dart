import 'package:fitness_app/api/services/notifications/notifications_service.dart';
import 'package:fitness_app/screen/diary/components/diary.dart';
import 'package:flutter/foundation.dart';

import 'models/filter_notifications_response.dart';
import 'models/food_response.dart';
import 'models/notification_response.dart';
import 'models/unread_notification_response.dart';

class NotificationsRepository {
  final _service = NotificationsService();

  Future<UnreadNotificationResponse> getUnreadNotification({
    required String id,
  }) async {
    try {
      final response = await _service.getUnreadNotification(
        id: id,
      );
      if (response.statusCode == 200) {
        final result = UnreadNotificationResponse.fromJson(response.data);
        return result;
      } else {
        return UnreadNotificationResponse();
      }
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
      return UnreadNotificationResponse();
    }
  }

  Future<void> resetUnreadNotification({
    required String id,
  }) async {
    try {
      await _service.resetUnreadNotification(
        id: id,
      );
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
    }
  }

  Future<FilterNotificationsResponse> filterNotifications({
    required String id,
    required int page,
  }) async {
    try {
      final response = await _service.filterNotifications(
        id: id,
        page: page.toString(),
      );
      if (response.statusCode == 200) {
        final totalPages = response.headers['total-record'];
        final data = NotificationResponse.fromJsonArray(response.data);
        return FilterNotificationsResponse(
          totalPages: totalPages != null ? int.parse(totalPages[0]) : 0,
          data: data,
        );
      } else {
        return FilterNotificationsResponse();
      }
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
      return FilterNotificationsResponse();
    }
  }

  Future<Diary?> getDiaryNotifications({
    required String url,
  }) async {
    try {
      final response = await _service.getDiaryNotifications(
        url: url,
      );
      if (response.statusCode == 200) {
        final result = Diary.fromJson(response.data);
        return result;
      } else {
        return null;
      }
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
      return null;
    }
  }

  Future<List<FoodResponse>> getSuggesstionNotifications({
    required String url,
  }) async {
    try {
      final response = await _service.getSuggesstionNotifications(
        url: url,
      );
      if (response.statusCode == 200) {
        final result = FoodResponse.fromJsonArray(response.data);
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
