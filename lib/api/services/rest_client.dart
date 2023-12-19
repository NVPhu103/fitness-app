import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:fitness_app/api/exception/api_endpoints.dart';
import 'package:flutter/foundation.dart';

typedef ApiErrorCallback = Function(
    DioError e, ErrorInterceptorHandler handler);

class RestClient {
  static const kTimeout = 20000;
  static const kEnableLog = kDebugMode;
  static const kAccessToken = 'access_token';
  static const kDeviceId = "x-device-id";
  static const kDeviceType = "x-device-type";

  static List<int>? sslCert;

  static Dio dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(milliseconds: kTimeout),
    receiveTimeout: const Duration(milliseconds: kTimeout),
    // headers: _headers,
    responseType: ResponseType.json,
  ));

  late Map<String, dynamic> _headers;

  void init({
    String? deviceId,
    String? userAgent,
    String? accessToken,
    ApiErrorCallback? errorCallback,
  }) {
    _headers = {
      'Content-Type': 'application/json',
      kAccessToken: '$accessToken',
      kDeviceId: deviceId,
      kDeviceType: "2",
    };

    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: kTimeout),
      receiveTimeout: const Duration(milliseconds: kTimeout),
      headers: _headers,
      responseType: ResponseType.json,
    ));

    final httpClientAdapter = DefaultHttpClientAdapter();
    dio.httpClientAdapter = httpClientAdapter;
  }

  void setToken(String token) {
    dio.options.headers[kAccessToken] = token;
  }

  void setBaseUrl(String baseUrl) {
    dio.options.baseUrl = baseUrl;
  }

  void clearToken() {
    _headers.remove(kAccessToken);
  }
}
