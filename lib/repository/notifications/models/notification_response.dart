import 'package:json_annotation/json_annotation.dart';

part 'notification_response.g.dart';

@JsonSerializable()
class NotificationResponse {
  String? title;
  String? content;
  String? url;
  String? page;
  String? created;

  NotificationResponse({
    this.title,
    this.content,
    this.url,
    this.page,
    this.created,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return _$NotificationResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);

  static List<NotificationResponse> fromJsonArray(
    List<dynamic> jsonArray,
  ) {
    return jsonArray
        .map(
          (dynamic e) =>
              NotificationResponse.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
