import 'dart:convert';

import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../offline/prefs_manager.dart';
import 'dio_exceptions.dart';
import 'interceptor/token_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient.internal();

  factory DioClient() => _instance;

  static late Dio _dio;

  DioClient.internal();

  Future<void> initDioClient() async {
    final serverUrl = dotenv.env["BASE_URL"] ?? '';
    _dio = Dio(
      BaseOptions(
        baseUrl: "$serverUrl/business-card/",
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    final tokenInterceptor = TokenInterceptor(_dio);

    _dio.interceptors.addAll([
      tokenInterceptor,
      AwesomeDioInterceptor(logger: print),
    ]);
  }

  // get endpoint
  Future get(
    String endpoint, [
    Map<String, dynamic>? queryParameters,
    String token = '',
  ]) async {
    Response response;
    try {
      _dio.options.baseUrl = "${dotenv.env["BASE_URL"]}/business-card/";
      response = await _dio.get(endpoint, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw (errorMessage);
    }
  }

  // post endpoint
  Future<dynamic> post(
    String endpoint,
    dynamic body, {
    bool includeAuth = true,
    String contentType = Headers.jsonContentType,
  }) async {
    Response response;

    //final token = PrefsManager().getToken();

    final Map<String, String> headers = {'Content-Type': contentType};

   /* if (includeAuth && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }*/

    try {
      debugPrint("Body: $body");
      Options options = Options(
        headers: headers,
        extra: includeAuth ? null : {'skipAuth': true},
      );
      response = await _dio.post(endpoint, data: body, options: options);

      return response.data;
    } on DioException catch (e) {
      debugPrint("Error Message: ${e.message}");
      if (e.response != null) {
        debugPrint("Error Response Data: ${e.response?.data}");
        debugPrint("Error Response Headers: ${e.response?.headers}");
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw (errorMessage);
    }
  }

  Future<dynamic> patch(
    String endpoint,
    dynamic data, {
    Map<String, dynamic>? headers,
  }) async {
    try {
      if (data is Map<String, dynamic>) {
        data = json.encode(data);
      }

      Options options = Options(headers: headers);
      final response = await _dio.patch(endpoint, data: data, options: options);
      return response.data;
    } on DioException catch (e) {
      debugPrint("Error Message: ${e.message}");
      if (e.response != null) {
        debugPrint("Error Response Data: ${e.response?.data}");
        debugPrint("Error Response Headers: ${e.response?.headers}");
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw (errorMessage);
    }
  }

  Future<dynamic> put(String endpoint, dynamic data) async {
    try {
     // final token = await PrefsManager().getToken();

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
       // 'Authorization': 'Bearer $token',
      };
      Options options = Options(headers: headers);
      final response = await _dio.put(endpoint, data: data, options: options);
      return response.data;
    } on DioException catch (e) {
      debugPrint("Error Message: ${e.message}");
      if (e.response != null) {
        debugPrint("Error Response Data: ${e.response?.data}");
        debugPrint("Error Response Headers: ${e.response?.headers}");
      }
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw (errorMessage);
    }
  }
}
