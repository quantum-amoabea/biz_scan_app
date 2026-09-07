import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../offline/prefs_manager.dart';
import '../dio_client.dart';

class TokenInterceptor extends Interceptor {
  final Dio _dio;
  bool _isRefreshing = false;
  late final Queue<PendingRequest> _queue;
  static VoidCallback? onLogout;

  TokenInterceptor(this._dio) {
    _queue = Queue();
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = PrefsManager().getAccessToken();
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final msg = err.response?.data['error_message'];

    if (status == 401 && msg == 'InvalidToken') {
      if (!_isRefreshing) {
        _isRefreshing = true;

        try {
          final refreshToken = PrefsManager().getRefreshToken();

          if (refreshToken.isEmpty) {
            _handleLogout();
            for (final pending in _queue) {
              pending.handler.reject(err);
            }
            _queue.clear();
            _isRefreshing = false;
            return;
          }

          await _refreshToken(refreshToken);

          final newToken = PrefsManager().getAccessToken();

          if (newToken.isEmpty) {
            _handleLogout();
            for (final pending in _queue) {
              pending.handler.reject(err);
            }
            _queue.clear();
            _isRefreshing = false;
            return;
          }

          for (final pending in _queue) {
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
            pending.handler.resolve(clone);
          }
        } catch (e) {
          _handleLogout();
          for (final pending in _queue) {
            pending.handler.reject(err);
          }
        } finally {
          _queue.clear();
          _isRefreshing = false;
        }
      } else {
        _queue.add(PendingRequest(err.requestOptions, handler));
      }
    } else {
      handler.next(err);
    }
  }

  Future<void> _refreshToken(String refreshToken) async {
    try {
      final response = await DioClient.refreshDio.post(
        'api/v1/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newData = response.data;
      final newAccessToken = newData['access_token'] as String?;

      if (newAccessToken != null) {
        await PrefsManager().setAccessToken(newAccessToken);
      }
    } catch (e) {
      debugPrint('Token refresh failed: $e');
      rethrow;
    }
  }

  void _handleLogout() {
    PrefsManager().clearAll();
    TokenInterceptor.onLogout?.call();
  }
}

class PendingRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  PendingRequest(this.options, this.handler);
}
