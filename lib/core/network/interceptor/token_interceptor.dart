import 'dart:async';
import 'dart:collection';
import 'package:biz_scan_app/models/login_user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../offline/prefs_manager.dart';


class TokenInterceptor extends Interceptor {
  final Dio _dio;
  bool _isRefreshing = false;
  late final Queue<PendingRequest> _queue;

  TokenInterceptor(this._dio) {
    _queue = Queue();
    debugPrint('TokenInterceptor initialized');
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint(
        'TokenInterceptor onRequest -> ${options.method} ${options.path}');
    final token = PrefsManager().getToken();
    // ignore: unnecessary_null_comparison
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      debugPrint('Added Authorization header: Bearer $token');
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final msg = err.response?.data['detail'];
    debugPrint('TokenInterceptor onError -> status: $status, message: $msg');
    if (status == 401 && msg == 'Could not validate credentials') {
      debugPrint('Queueing failed request: ${err.requestOptions.path}');
      _queue.add(PendingRequest(err.requestOptions, handler));
      if (!_isRefreshing) {
        _isRefreshing = true;
        debugPrint('Refreshing token...');
        try {
          await _refreshToken();
          final newToken = await PrefsManager().getToken();
          debugPrint('New token acquired: $newToken');
          for (final pending in _queue) {
            debugPrint('Retrying request: ${pending.options.path}');
            pending.options.headers['Authorization'] = 'Bearer $newToken';
            final clone = await _dio.request(
              pending.options.path,
              data: pending.options.data,
              queryParameters: pending.options.queryParameters,
              options: Options(
                method: pending.options.method,
                headers: pending.options.headers,
              ),
            );
            debugPrint('Response for retried request: ${clone.statusCode}');
            pending.handler.resolve(clone);
          }
        } catch (e) {
          debugPrint('Error refreshing token: $e');
          for (final pending in _queue) {
            pending.handler.next(err);
          }
        } finally {
          _queue.clear();
          _isRefreshing = false;
          debugPrint('Token refresh process completed');
        }
      }
    } else {
      handler.next(err);
    }
  }

  Future<void> _refreshToken() async {
    debugPrint('TokenInterceptor _refreshToken called');
    final username = await PrefsManager().getUsername();
    final password = await PrefsManager().getPassword();
    final credentials =
        LoginUser(username: username, password: password);
    debugPrint('Refreshing token with credentials for user: $username');

    final response = await _dio.post(
      'token',
      options: Options(contentType: Headers.formUrlEncodedContentType),
      data: credentials.toJson(),
    );
    debugPrint(
        'Refresh token response: ${response.statusCode} ${response.data}');

    final newToken = response.data['access_token'];
    await PrefsManager().setToken(newToken);
    debugPrint('Token saved to PrefsManager');
  }
}

class PendingRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;
  PendingRequest(this.options, this.handler);
}