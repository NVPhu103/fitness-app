import 'package:json_annotation/json_annotation.dart';

part 'api_exception.g.dart';

@JsonSerializable()
class ApiException implements Exception {
  final int statusCode;
  final int result;
  final String message;

  ApiException({
    required this.statusCode,
    required this.result,
    required this.message,
  });

  factory ApiException.fromJson(Map<String, dynamic> json) =>
      _$ApiExceptionFromJson(json);

  Map<String, dynamic> toJson() => _$ApiExceptionToJson(this);
}
