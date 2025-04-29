import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart' as dio;
import 'package:store_go/app/core/config/app_config.dart';
import 'package:synchronized/synchronized.dart';

/// Manages authentication tokens - storage, refresh, validation
class TokenManager {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Logger _logger = Logger();
  final _refreshLock = Lock();

  // Save all session data
  Future<void> saveSessionData(Map<String, dynamic> session) async {
    final accessToken = session['accessToken'];
    final refreshToken = session['refreshToken'];
    final expiresAt = session['expiresAt'];
    final userId = session['userId'];

    await _secureStorage.write(key: 'access_token', value: accessToken);
    _logger.i('access_token saved');

    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
    _logger.i('refresh_token saved');

    await _secureStorage.write(key: 'expires_at', value: expiresAt);
    _logger.i('expires_at saved');

    if (userId != null) {
      await _secureStorage.write(key: 'user_id', value: userId);
      _logger.i('user_id saved');
    }
  }

  // Save additional user data
  Future<void> saveUserData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
    _logger.i('$key saved');
  }

  // Get access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  // Get user ID
  Future<String?> getUserId() async {
    return await _secureStorage.read(key: 'user_id');
  }

  // Clear all stored tokens
  Future<void> clearAllTokens() async {
    await _secureStorage.deleteAll();
    _logger.i('All tokens cleared');
  }

  // Check if we have a valid access token
  Future<bool> hasValidAccessToken() async {
    final token = await _secureStorage.read(key: 'access_token');
    return token != null;
  }

  // Check if token needs refresh and refresh if needed
  Future<bool> checkAndRefreshTokenIfNeeded() async {
    try {
      final token = await _secureStorage.read(key: 'access_token');
      if (token == null) {
        _logger.w('No access token found');
        return false;
      }

      final expiresAtStr = await _secureStorage.read(key: 'expires_at');
      if (expiresAtStr == null) {
        _logger.w('No token expiration info found');
        return false;
      }

      final expiresAt = DateTime.parse(expiresAtStr);
      final now = DateTime.now();

      // If token is already expired, try to refresh it
      if (now.isAfter(expiresAt)) {
        _logger.i('Token expired, attempting refresh');
        return await refreshToken();
      }

      // Refresh if less than 5 minutes until expiration
      if (expiresAt.difference(now).inMinutes < 5) {
        _logger.i('Token expiring soon, attempting refresh');
        return await refreshToken();
      }

      _logger.i('Token is valid');
      return true;
    } catch (e) {
      _logger.e('Error checking token expiration: $e');
      return false;
    }
  }

  // Refresh the token
  Future<bool> refreshToken() async {
    // Use the lock to prevent concurrent refresh attempts
    return _refreshLock.synchronized(() async {
      try {
        // Get the CURRENT refresh token
        final refreshToken = await _secureStorage.read(key: 'refresh_token');
        _logger.i('Refresh token: $refreshToken');

        if (refreshToken == null) return false;

        // Create a clean Dio instance for the refresh request
        final refreshDio = dio.Dio(
          dio.BaseOptions(
            baseUrl: AppConfig.baseUrl,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'X-Store-ID': AppConfig.storeId,
            },
          ),
        );

        // Make the refresh request
        final response = await refreshDio.post(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200) {
          final accessToken = response.data['session']['accessToken'];
          final newRefreshToken = response.data['session']['refreshToken'];
          final expiresAt = response.data['session']['expiresAt'];

          // Store all tokens atomically
          await Future.wait([
            _secureStorage.write(key: 'access_token', value: accessToken),
            _secureStorage.write(key: 'refresh_token', value: newRefreshToken),
            _secureStorage.write(key: 'expires_at', value: expiresAt),
          ]);

          _logger.i('Token refreshed successfully');
          return true;
        }
        return false;
      } catch (e) {
        _logger.e('Error refreshing token: $e');

        // If error is 'refresh_token_already_used', it means another refresh happened
        // In this case, just check if we have valid tokens
        if (e.toString().contains('refresh_token_already_used')) {
          final expiresAtStr = await _secureStorage.read(key: 'expires_at');
          final token = await _secureStorage.read(key: 'access_token');

          if (expiresAtStr != null && token != null) {
            final expiresAt = DateTime.parse(expiresAtStr);
            if (DateTime.now().isBefore(expiresAt)) {
              // We already have valid tokens from another refresh
              return true;
            }
          }
        }

        return false;
      }
    });
  }
}
