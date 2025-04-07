import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/auth/services/notification_service.dart';

/// Centralized error handling for authentication operations
class AuthErrorHandler {
  final NotificationService _notificationService = NotificationService();
  final Logger _logger = Logger();

  // Handle sign up errors
  void handleSignUpError(dynamic error) {
    if (error is DioException) {
      // Extract specific error message from response when available
      String errorMessage = 'An unexpected error occurred';

      if (error.response != null && error.response!.data != null) {
        // Check different formats the error might come in
        if (error.response!.data is Map) {
          // Try to extract error message from common fields
          errorMessage =
              error.response!.data['error'] ??
              error.response!.data['message'] ??
              error.response!.data['errorMessage'] ??
              'Error ${error.response!.statusCode}';

          _logger.e("API error: $errorMessage");
        } else if (error.response!.data is String) {
          errorMessage = error.response!.data;
          _logger.e("API error: $errorMessage");
        }
      }

      // Handle specific status codes
      if (error.response?.statusCode == 400) {
        _notificationService.showError(errorMessage);
      } else if (error.response?.statusCode == 404) {
        // Specifically handle 404 errors
        _notificationService.showError(errorMessage);
      } else {
        _notificationService.showError(errorMessage);
      }
    } else {
      _notificationService.showError('An unexpected error occurred');
    }
  }

  // Handle sign in errors
  void handleSignInError(dynamic error) {
    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        _notificationService.showError('Invalid email or password');
      } else {
        _notificationService.showError('Authentication failed');
      }
    } else {
      _notificationService.showError('An unexpected error occurred');
    }
  }

  // Handle OAuth errors
  void handleOAuthError(dynamic error) {
    _logger.e('OAuth error: $error');
    if (error is DioException) {
      _logger.e('DioException details: ${error.response?.data}');
    }
    _notificationService.showError('Authentication failed');
  }

  // Handle token refresh errors
  void handleTokenRefreshError(dynamic error) {
    _logger.e('Token refresh error: $error');
    _notificationService.showError('Session expired, please log in again');
  }
}
