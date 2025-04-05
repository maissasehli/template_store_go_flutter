import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/config/app_config.dart';
import 'package:store_go/app/core/services/api_client.dart';
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
          'storeId': AppConfig.storeId,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Save the access token
        final accessToken = response.data['session']['accessToken'];
        await _secureStorage.write(key: 'access_token', value: accessToken);
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
        return true;
      }
      return false;
    } catch (e) {
      Logger().e(e.toString());
      if (e is DioException) {
        // Extract specific error message from response when available
        String errorMessage = 'An unexpected error occurred';

        if (e.response != null && e.response!.data != null) {
          // Check different formats the error might come in
          if (e.response!.data is Map) {
            // Try to extract error message from common fields
            errorMessage =
                e.response!.data['error'] ??
                e.response!.data['message'] ??
                e.response!.data['errorMessage'] ??
                'Error ${e.response!.statusCode}';

            Logger().e("API error: $errorMessage");
          } else if (e.response!.data is String) {
            errorMessage = e.response!.data;
            Logger().e("API error: $errorMessage");
          }
        }

        // Handle specific status codes
        if (e.response?.statusCode == 400) {
          _showErrorAlert(errorMessage);
        } else if (e.response?.statusCode == 404) {
          // Specifically handle 404 errors
          _showErrorAlert(errorMessage);
        } else {
          _showErrorAlert(errorMessage);
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
          'storeId': AppConfig.storeId,
        },
      );

      if (response.statusCode == 200) {
        // Save the access token
        final accessToken = response.data['session']['accessToken'];
        await _secureStorage.write(key: 'access_token', value: accessToken);
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
      final token = await _secureStorage.read(key: 'access_token');
      if (token == null) return false;

      final response = await _apiClient.post('/auth/refresh');

      if (response.statusCode == 200) {
        final newToken = response.data['token']['accessToken'];
        await _secureStorage.write(key: 'access_token', value: newToken);
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
  // Check if token needs refresh and refresh if needed
  Future<bool> checkAndRefreshTokenIfNeeded() async {
    try {
      final token = await _secureStorage.read(key: 'access_token');
      if (token == null) {
        Logger().w('No access token found');
        return false;
      }

      final expiresAtStr = await _secureStorage.read(key: 'expires_at');
      if (expiresAtStr == null) {
        Logger().w('No token expiration info found');
        return false;
      }

      final expiresAt = DateTime.parse(expiresAtStr);
      final now = DateTime.now();

      // If token is already expired, try to refresh it
      if (now.isAfter(expiresAt)) {
        Logger().i('Token expired, attempting refresh');
        return await _refreshToken();
      }

      // Refresh if less than 5 minutes until expiration
      if (expiresAt.difference(now).inMinutes < 5) {
        Logger().i('Token expiring soon, attempting refresh');
        return await _refreshToken();
      }

      Logger().i('Token is valid');
      return true;
    } catch (e) {
      Logger().e('Error checking token expiration: $e');
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
    final token = await _secureStorage.read(key: 'access_token');
    return token != null;
  }

  /// Initiates OAuth flow for the given provider
  /// Returns the URL to be opened in a WebView or browser
  Future<String?> initiateOAuth({
    required String provider,
    required String redirectUrl,
  }) async {
    try {
      Logger().i('Initiating OAuth flow for provider: $provider');

      final response = await _apiClient.post(
        '/auth/oauth/initiate',
        data: {
          'provider': provider,
          'storeId': AppConfig.storeId,
          'redirectUrl': redirectUrl,
        },
      );

      if (response.statusCode == 200) {
        final authUrl = response.data['authUrl'];
        Logger().i('OAuth auth URL generated: $authUrl');
        return authUrl;
      } else {
        Logger().e('Failed to initiate OAuth: ${response.statusCode}');
        _showErrorAlert('Failed to initiate authentication');
        return null;
      }
    } catch (e) {
      Logger().e('Error initiating OAuth: $e');
      _showErrorAlert('Authentication failed');
      return null;
    }
  }

  /// Complete OAuth flow using WebView
  Future<bool> completeOAuthFlow({
    required String provider,
    String? callbackUrlScheme,
  }) async {
    try {
      Logger().i('Starting complete OAuth flow for provider: $provider');

      // Define redirect URL with custom scheme for mobile app
      final redirectUrl =
          '${callbackUrlScheme ?? 'com.storego'}://oauth-callback';

      // 1. Get authorization URL from backend
      final authUrl = await initiateOAuth(
        provider: provider,
        redirectUrl: redirectUrl,
      );

      if (authUrl == null) {
        Logger().e('Failed to get OAuth authorization URL');
        return false;
      }

      // 2. Open WebView for user authentication
      Logger().i('Opening WebView for OAuth authentication');
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: callbackUrlScheme ?? 'com.storego',
      );

      Logger().i('Got callback URL: $result');

      // 3. Parse the resulting URL
      final uri = Uri.parse(result);

      // Check if we're dealing with an authorization code flow (code in query parameters)
      final code = uri.queryParameters['code'];

      if (code != null) {
        // Handle authorization code flow
        Logger().i('OAuth code received, exchanging for tokens');

        // Exchange code for tokens
        final response = await _apiClient.post(
          '/auth/oauth/callback',
          data: {'code': code, 'storeId': AppConfig.storeId},
        );

        if (response.statusCode == 200) {
          // Save tokens from response
          await _saveTokensFromResponse(response.data['session']);
          _showSuccessAlert('Successfully signed in');
          return true;
        } else {
          Logger().e(
            'Failed to exchange code for tokens: ${response.statusCode}',
          );
          _showErrorAlert('Authentication failed');
          return false;
        }
      } else {
        // Handle implicit flow (token in URL fragment)
        Logger().i('No code parameter found, checking for tokens in fragment');

        // Extract and parse the fragment properly
        final fragment = uri.fragment;
        if (fragment.isEmpty) {
          Logger().e('No fragment found in callback URL');
          _showErrorAlert('Authentication failed');
          return false;
        }

        // Parse fragment parameters correctly
        final fragmentParams = Uri.splitQueryString(fragment);
        final accessToken = fragmentParams['access_token'];
        final refreshToken = fragmentParams['refresh_token'];
        final expiresIn = fragmentParams['expires_in'];
        final providerToken = fragmentParams['provider_token'];

        Logger().i(
          'Fragment parsed, access token found: ${accessToken != null}',
        );

        if (accessToken == null) {
          Logger().e('No access token found in callback URL fragment');
          _showErrorAlert('Authentication failed');
          return false;
        }

        // If we have both tokens, we can directly save them
        await _secureStorage.write(key: 'access_token', value: accessToken);
        Logger().i('access_token saved');

        if (refreshToken != null) {
          await _secureStorage.write(key: 'refresh_token', value: refreshToken);
          Logger().i('refresh_token saved');
        }

        // Calculate and save expiration time
        final expiresAt = _calculateExpiresAt(expiresIn);
        await _secureStorage.write(key: 'expires_at', value: expiresAt);
        Logger().i('expires_at saved');

        // If we have a provider token, we can use it to get user details from the backend
        if (providerToken != null) {
          Logger().i('Provider token found, fetching user data');
          try {
            // Use the signInWithProviderToken method to get user details
            final success = await signInWithProviderToken(
              provider: provider,
              providerToken: providerToken,
            );

            if (success) {
              _showSuccessAlert('Successfully signed in');
              return true;
            }
          } catch (e) {
            Logger().e('Error using provider token: $e');
            // Continue with the flow even if this fails
          }
        }

        // At this point, we have at least saved the access token and can consider the sign-in successful
        // You might need to add additional calls to get user details if needed
        _showSuccessAlert('Successfully signed in');
        return true;
      }
    } catch (e) {
      Logger().e('Error completing OAuth flow: $e');
      if (e is DioException) {
        Logger().e('DioException: ${e.response?.data}');
      }
      _showErrorAlert('Authentication failed');
      return false;
    }
  }

  // Helper method to calculate expiration time
  String _calculateExpiresAt(String? expiresInStr) {
    final expiresIn = int.tryParse(expiresInStr ?? '3600') ?? 3600;
    final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    return expiresAt.toIso8601String();
  }

  // Helper method to save tokens
  Future<void> _saveTokensFromResponse(Map<String, dynamic> session) async {
    final accessToken = session['accessToken'];
    final refreshToken = session['refreshToken'];
    final expiresAt = session['expiresAt'];
    final userId = session['userId'];

    await _secureStorage.write(key: 'access_token', value: accessToken);
    Logger().i('access_token saved');

    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
    Logger().i('refresh_token saved');

    await _secureStorage.write(key: 'expires_at', value: expiresAt);
    Logger().i('expires_at saved');

    if (userId != null) {
      await _secureStorage.write(key: 'user_id', value: userId);
      Logger().i('user_id saved');
    }
  }

  /// Direct sign-in with OAuth provider token
  /// This is useful when you already have a token from a native SDK
  Future<bool> signInWithProviderToken({
    required String provider,
    required String providerToken,
  }) async {
    try {
      Logger().i('Signing in with provider token for: $provider');

      final response = await _apiClient.post(
        '/auth/oauth/sign-in',
        data: {
          'provider': provider,
          'providerToken': providerToken,
          'storeId': AppConfig.storeId,
        },
      );

      if (response.statusCode == 200) {
        // Save tokens
        final accessToken = response.data['session']['accessToken'];
        final refreshToken = response.data['session']['refreshToken'];
        final expiresAt = response.data['session']['expiresAt'];
        final userId = response.data['session']['userId'];

        await _secureStorage.write(key: 'access_token', value: accessToken);
        Logger().i('access_token saved');

        await _secureStorage.write(key: 'refresh_token', value: refreshToken);
        Logger().i('refresh_token saved');

        await _secureStorage.write(key: 'expires_at', value: expiresAt);
        Logger().i('expires_at saved');

        await _secureStorage.write(key: 'user_id', value: userId);
        Logger().i('user_id saved');

        _showSuccessAlert('Successfully signed in');
        return true;
      } else {
        Logger().e(
          'Failed to sign in with provider token: ${response.statusCode}',
        );
        _showErrorAlert('Authentication failed');
        return false;
      }
    } catch (e) {
      Logger().e('Error signing in with provider token: $e');
      if (e is DioException) {
        Logger().e('DioException details: ${e.response?.data}');
      }
      _showErrorAlert('Authentication failed');
      return false;
    }
  }

  /// Link an existing account with an OAuth provider
  Future<bool> linkOAuthProvider({
    required String provider,
    required String providerToken,
  }) async {
    try {
      Logger().i('Linking account with provider: $provider');

      // Get current user ID
      final userId = await _secureStorage.read(key: 'user_id');
      if (userId == null) {
        Logger().e('No user ID found, cannot link account');
        _showErrorAlert('You must be logged in to link accounts');
        return false;
      }

      final response = await _apiClient.post(
        '/auth/oauth/link',
        data: {
          'userId': userId,
          'provider': provider,
          'providerToken': providerToken,
          'storeId': AppConfig.storeId,
        },
      );

      if (response.statusCode == 200) {
        Logger().i('Successfully linked $provider account');
        _showSuccessAlert('Account linked successfully');
        return true;
      } else {
        Logger().e('Failed to link provider: ${response.statusCode}');
        _showErrorAlert('Failed to link account');
        return false;
      }
    } catch (e) {
      Logger().e('Error linking OAuth provider: $e');
      _showErrorAlert('Failed to link account');
      return false;
    }
  }

  // Handle app resume - check if the token is still valid
 Future<void> handleAppResume() async {
    try {
      // Check if user is authenticated first
      final userAuthenticated = await isAuthenticated();
      if (!userAuthenticated) {
        // If not authenticated, nothing to do
        return;
      }

      // Check if token is still valid or can be refreshed
      final hasValidToken = await checkAndRefreshTokenIfNeeded();
      if (!hasValidToken) {
        // If token is invalid and can't be refreshed, log out
        await _secureStorage.deleteAll();
        // If user is on a protected route, redirect to login
        if (!AppRoute.publicRoutes.contains(Get.currentRoute)) {
          Get.offAllNamed(AppRoute.login);
        }
      }
    } catch (e) {
      Logger().e('Error in handleAppResume: $e');
    }
  }
  // Add this method to AuthService class
  Future<bool> _refreshToken() async {
    try {
      // Get the refresh token
      final refreshToken = await _secureStorage.read(key: 'refresh_token');
      if (refreshToken == null) {
        Logger().w('No refresh token found');
        return false;
      }

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
