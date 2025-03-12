import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes_constants.dart';
import 'package:store_go/core/constants/api_constants.dart';
import 'package:store_go/core/services/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Centralized error handling method
  void _showErrorAlert(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );
  }

  // Centralized success handling method
  void _showSuccessAlert(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );
  }

  // Sign up method using secure backend proxy
  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/sign-up',
        data: {
          'email': email,
          'password': password,
          'name': '$firstName $lastName',
          'storeId': ApiConstants.storeId,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Save the access token
        final token = response.data['session']['accessToken'];
        await _secureStorage.write(key: 'auth_token', value: token);
        Logger().i('access_token saved');
        // save refresh token
        final refreshToken = response.data['session']['refreshToken'];
        await _secureStorage.write(key: 'refresh_token', value: refreshToken);
        Logger().i('refresh_token saved');
        // Save expiration time
        await _secureStorage.write(
          key: 'expires_at',
          value: response.data['session']['expiresAt'],
        );
        Logger().i('expires_at saved');

        // Save user ID if needed
        await _secureStorage.write(
          key: 'user_id',
          value: response.data['session']['userId'],
        );
        Logger().i('user_id saved');
        _showSuccessAlert('Account created successfully');
        return true;
      }
      return false;
    } catch (e) {
      Logger().e(e.toString());
      if (e is DioException) {
        if (e.response?.statusCode == 400) {
          Logger().e("error during signup : ${e.response?.data['error']}");
          _showErrorAlert(e.response?.data['error'] ?? 'Invalid input');
        } else {
          _showErrorAlert('An unexpected error occurred: ${e.toString()}');
        }
      } else {
        _showErrorAlert('An unexpected error occurred');
      }
      return false;
    }
  }

  // Sign in method using secure backend proxy
  Future<bool> signIn({required String email, required String password}) async {
    try {
      final response = await _apiClient.post(
        '/auth/sign-in',
        data: {
          'email': email,
          'password': password,
          'storeId': ApiConstants.storeId,
        },
      );

      if (response.statusCode == 200) {
        // Save the token
        final token = response.data['token']['accessToken'];
        await _secureStorage.write(key: 'auth_token', value: token);

        // Save other user information if needed
        await _secureStorage.write(
          key: 'user_id',
          value: response.data['token']['userId'],
        );
        await _secureStorage.write(
          key: 'expires_at',
          value: response.data['token']['expiresAt'],
        );

        _showSuccessAlert('Successfully logged in');
        return true;
      }
      return false;
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          _showErrorAlert('Invalid email or password');
        } else {
          _showErrorAlert('Authentication failed');
        }
      } else {
        _showErrorAlert('An unexpected error occurred');
      }
      return false;
    }
  }

  // Token refresh method
  Future<bool> refreshToken() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      if (token == null) return false;

      final response = await _apiClient.post('/auth/refresh');

      if (response.statusCode == 200) {
        final newToken = response.data['token']['accessToken'];
        await _secureStorage.write(key: 'auth_token', value: newToken);
        await _secureStorage.write(
          key: 'expires_at',
          value: response.data['token']['expiresAt'],
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Check if token needs refresh
  Future<bool> checkAndRefreshTokenIfNeeded() async {
    try {
      final expiresAtStr = await _secureStorage.read(key: 'expires_at');
      if (expiresAtStr == null) return false;

      final expiresAt = DateTime.parse(expiresAtStr);
      final now = DateTime.now();

      // Refresh if less than 5 minutes until expiration
      if (expiresAt.difference(now).inMinutes < 5) {
        return await refreshToken();
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      await _apiClient.post('/auth/sign-out');
      // Clear local storage
      await _secureStorage.deleteAll();
      _showSuccessAlert('Successfully logged out');
      Get.offAllNamed(AppRoute.login);
    } catch (e) {
      _showErrorAlert('Failed to log out');
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: 'auth_token');
    return token != null;
  }
}
