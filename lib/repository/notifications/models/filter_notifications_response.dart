import 'notification_response.dart';

class FilterNotificationsResponse {
  int? totalPages;
  List<NotificationResponse>? data;

  FilterNotificationsResponse({
    this.totalPages,
    this.data,
  });
}
