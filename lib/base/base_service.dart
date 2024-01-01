import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:fitness_app/api/exception/api_exception.dart';
import 'package:fitness_app/api/services/rest_client.dart';
import 'package:logger/logger.dart';

abstract class BaseService {
  final Logger _logger = Logger();

  Future<dynamic> get(String path, {Map<String, dynamic>? params}) async {
    final response = await RestClient.dio.get(path, queryParameters: params);
    _logger.i('path: $path \nparams: $params\nresponse: $response');
    return _handleResponse(response);
  }

  Future<dynamic> post(String path,
      {Map<String, dynamic>? data,
      List<String>? dataList,
      ignoreResultCode = false,
      String? dataKey}) async {
    final response = await RestClient.dio
        .post(path, data: dataList != null ? jsonEncode(dataList) : data);
    _logger.i('path: $path \ndata: $data\nresponse: $response');
    return _handleResponse(response);
  }

  Future<dynamic> uploadImage(String path, {dio.FormData? formData}) async {
    final response = await RestClient.dio.post(path, data: formData);
    _logger.i('path: $path \ndata: $formData\nresponse: $response');
    return response;
  }

  Future<dynamic> put(String path,
      {Map<String, dynamic>? data,
      ignoreResultCode = false,
      String? dataKey}) async {
    final response = await RestClient.dio.put(path, data: data);
    _logger.i('path: $path \ndata: $data\nresponse: $response');
    return _handleResponse(response);
  }

  Future<dynamic> patch(String path,
      {Map<String, dynamic>? data,
      ignoreResultCode = false,
      String? dataKey}) async {
    final response = await RestClient.dio.patch(path, data: data);
    _logger.i('path: $path \ndata: $data\nresponse: $response');
    return _handleResponse(response);
  }

  Future<dynamic> delete(String path,
      {Map<String, dynamic>? data,
      ignoreResultCode = false,
      String? dataKey}) async {
    final response = await RestClient.dio.delete(path, data: data);
    _logger.i('path: $path \ndata: $data\nresponse: $response');
    return _handleResponse(response);
  }

  Future<dynamic> postFormData(String path, {dio.FormData? data}) async {
    final response = await RestClient.dio.post(path, data: data);
    _logger.i('path: $path \ndata: $data\nresponse: $response');
    return _handleResponse(response);
  }

  dynamic _handleResponse(dio.Response response) {
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ApiException.fromJson(response.data);
    }

    if (response.data is String) {
      return response.data;
    }
    return response;
  }
}
