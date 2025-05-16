import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioErrorInterceptor extends Interceptor {
  final BuildContext? context;

  DioErrorInterceptor({this.context});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Check if the response contains API response structure with success field
    if (response.data is Map && response.data.containsKey('success')) {
      if (response.data['success'] == false) {
        // Handle API error response
        final message = response.data['message'] ?? 'Unknown error occurred';
        debugPrint('❌ API Error: $message');

        if (context != null && _isContextMounted()) {
          ScaffoldMessenger.of(context!).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.orange));
        }
      }
    }

    // Continue with the response
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final message = _getErrorMessage(err);
    debugPrint('❌ Dio Error: $message');

    // If context is provided and is mounted, show a snackbar
    if (context != null && _isContextMounted()) {
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    }

    return super.onError(err, handler);
  }

  bool _isContextMounted() {
    try {
      return context?.mounted ?? false;
    } catch (e) {
      return false;
    }
  }

  String _getErrorMessage(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out';
      case DioExceptionType.sendTimeout:
        return 'Request timed out while sending data';
      case DioExceptionType.receiveTimeout:
        return 'Response timed out';
      case DioExceptionType.badResponse:
        return _handleBadResponse(err.response);
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      case DioExceptionType.unknown:
      default:
        if (err.error is SocketException) {
          return 'No internet connection';
        }
        return err.message ?? 'An unknown error occurred';
    }
  }

  String _handleBadResponse(Response? response) {
    if (response == null) return 'No response received';

    // Check if the response contains a message
    if (response.data is Map && response.data.containsKey('message')) {
      return response.data['message'].toString();
    }

    // Default status code based messages
    switch (response.statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Access denied';
      case 404:
        return 'Resource not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Error: ${response.statusCode}';
    }
  }
}
