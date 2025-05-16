import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../service/service_locator.dart';
import 'dio_interceptor.dart';

/// A service for managing global UI-related error handling
class ErrorHandlingService {
  /// Factory constructor to return the singleton instance
  factory ErrorHandlingService() => _instance;

  /// Private constructor
  ErrorHandlingService._();
  static final ErrorHandlingService _instance = ErrorHandlingService._();

  /// Set the current context for showing error snackbars
  void setContext(BuildContext context) {
    // Update the Dio interceptor with the new context
    final dio = ServiceLocator.get<Dio>();

    // Remove existing error interceptors
    dio.interceptors.removeWhere((interceptor) => interceptor is DioErrorInterceptor);

    // Add a new error interceptor with updated context
    dio.interceptors.add(DioErrorInterceptor(context: context));
  }

  /// Clear the context when it's no longer valid
  void clearContext() {}
}
