import 'package:dio/dio.dart' as dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:store_go/core/constants/api_constants.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes_constants.dart';
import 'package:logger/logger.dart';

class ApiClient {
  late dio.Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ApiClient() {
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Store-ID': ApiConstants.storeId,
        },
      ),
    );

    // Add interceptors for error handling, logging, etc.
    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          Logger().i('Interceptor onRequest has been triggered');

          // Bypass interceptor logic if current route is in public routes
          if (AppRoute.publicRoutes.contains(Get.currentRoute)) {
            Logger().i(
              'Interceptor onRequest: Bypassing interceptor logic for public route',
            );
            return handler.next(options);
          }

          // Get the token and check if it exists
          final token = await _secureStorage.read(key: 'auth_token');
          if (token == null) {
            Logger().w('Interceptor onRequest: No auth token found');
            Get.offAllNamed(AppRoute.login);
            return handler.reject(
              dio.DioException(
                requestOptions: options,
                error: 'No authentication token',
              ),
            );
          }

          // Check token expiration
          final expiresAtStr = await _secureStorage.read(key: 'expires_at');
          if (expiresAtStr != null) {
            final expiresAt = DateTime.parse(expiresAtStr);
            final now = DateTime.now();

            // If token is expired or about to expire (less than 5 minutes remaining)
            if (now.isAfter(expiresAt) ||
                expiresAt.difference(now).inMinutes < 5) {
              Logger().i(
                'Interceptor onRequest: Token expired or about to expire, refreshing',
              );

              // Try to refresh the token
              final refreshed = await _refreshToken();
              if (!refreshed) {
                // If refresh failed, if not in the public routes, redirect to login
                if (!AppRoute.publicRoutes.contains(Get.currentRoute)) {
                  Logger().e('Interceptor onRequest: Token refresh failed');
                  Get.offAllNamed(AppRoute.login);
                }
                return handler.reject(
                  dio.DioException(
                    requestOptions: options,
                    error: 'Authentication expired',
                  ),
                );
              }

              // Get the new token after refresh
              final newToken = await _secureStorage.read(key: 'auth_token');
              options.headers['Authorization'] = 'Bearer $newToken';
            } else {
              // Token is valid, add it to request
              options.headers['Authorization'] = 'Bearer $token';
            }
          } else {
            // No expiration info, just use the token we have
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (dio.DioException error, handler) async {
          Logger().e(
            'Interceptor onError has been triggered: ${error.message}',
          );

          // Handle 401 errors (Unauthorized)
          if (error.response?.statusCode == 401) {
            Logger().i(
              'Interceptor onError: Received 401 error, attempting token refresh',
            );

            // Try to refresh the token
            final refreshed = await _refreshToken();
            if (refreshed) {
              // If refresh was successful, retry the original request
              final originalRequest = error.requestOptions;
              final token = await _secureStorage.read(key: 'auth_token');

              // Create a new request with the same data but new token
              final response = await _dio.request(
                originalRequest.path,
                data: originalRequest.data,
                queryParameters: originalRequest.queryParameters,
                options: dio.Options(
                  method: originalRequest.method,
                  headers: {
                    ...originalRequest.headers,
                    'Authorization': 'Bearer $token',
                  },
                ),
              );

              // Return the new response
              return handler.resolve(response);
            } else {
              // If refresh failed, redirect to login
              Logger().e('Interceptor onError: Token refresh failed after 401');
              Get.offAllNamed(AppRoute.login);
            }
          }

          // For any other error, just pass it through
          return handler.next(error);
        },
      ),
    );
  }

  Future<dio.Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  Future<dio.Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<dio.Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<dio.Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } catch (e) {
      rethrow;
    }
  }

  // Add this method to your ApiClient class to handle token refreshing
  Future<bool> _refreshToken() async {
    try {
      // Don't use the intercepted client for refresh to avoid infinite loops
      final refreshToken = await _secureStorage.read(key: 'refresh_token');
      if (refreshToken == null) return false;

      // Create a clean Dio instance for the refresh request
      final refreshDio = dio.Dio(
        dio.BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-Store-ID': ApiConstants.storeId,
          },
        ),
      );

      // Make the refresh request
      final response = await refreshDio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        // Save the new tokens
        final accessToken = response.data['session']['accessToken'];
        final newRefreshToken = response.data['session']['refreshToken'];
        final expiresAt = response.data['session']['expiresAt'];

        // Store the new tokens
        await _secureStorage.write(key: 'auth_token', value: accessToken);
        await _secureStorage.write(
          key: 'refresh_token',
          value: newRefreshToken,
        );
        await _secureStorage.write(key: 'expires_at', value: expiresAt);

        Logger().i('Token refreshed successfully');
        return true;
      }
      return false;
    } catch (e) {
      Logger().e('Error refreshing token: $e');
      return false;
    }
  }
}
