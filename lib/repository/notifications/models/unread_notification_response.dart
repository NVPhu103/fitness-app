import 'package:json_annotation/json_annotation.dart';

part 'unread_notification_response.g.dart';

@JsonSerializable()
class UnreadNotificationResponse {
  int? unreadNotification;
  String? lastViewed;

  UnreadNotificationResponse({
    this.unreadNotification,
    this.lastViewed,
  });

  factory UnreadNotificationResponse.fromJson(Map<String, dynamic> json) {
    return _$UnreadNotificationResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UnreadNotificationResponseToJson(this);
}
