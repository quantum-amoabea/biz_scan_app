import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'error_message.dart';

class DioExceptions implements Exception {
  late String message;

  DioExceptions.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = ErrorMessage.requestCancelled;
        break;
      case DioExceptionType.connectionTimeout:
        message = ErrorMessage.connectionTimeout;
        break;
      case DioExceptionType.connectionError:
        message = ErrorMessage.connectionTimeout;
        break;
      case DioExceptionType.receiveTimeout:
        message = ErrorMessage.receieveTimeout;
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
        break;
      case DioExceptionType.sendTimeout:
        message = ErrorMessage.sendTimeout;
        break;
      case DioExceptionType.unknown:
        final String dioErrorMessage = dioError.message ?? "";
        if (dioError.error is SocketException ||
            dioErrorMessage.contains('SocketException')) {
          message = ErrorMessage.noInternet;
          break;
        }
        message = ErrorMessage.unexpectedError;
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

 String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        debugPrint("Details: ${error['detail']}");
        return error['detail'] != null && error['detail'].contains("Invalid")
            ? error['detail']
            : 'Oops, something went wrong with your request. Please check your input and try again.';
      case 401:
        return error['error_message'];
      case 403:
        return 'Access Denied. You do not have the necessary permissions to perform this action';
      case 404:
        return error['error_message'];
      case 409:
        return error['error_message'];
      case 500:
        return 'Oops, something went wrong on our end. Please try again later or contact support';
      case 502:
        return 'Oops, it looks like there is a problem with the server. Please try again later or contact support';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}
