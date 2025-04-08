
import 'package:logger/logger.dart';
import 'package:store_go/features/auth/services/auth_api_client.dart';
import 'package:store_go/features/auth/services/jwt_utils.dart';
import 'package:store_go/features/auth/services/token_manager.dart';
import 'package:store_go/features/auth/services/notification_service.dart';
import 'dart:async';

import 'package:store_go/features/auth/views/widgets/custom_webview.dart';

/// Handles OAuth authentication flows
class OAuthService {
  final AuthApiClient _apiClient = AuthApiClient();
  final TokenManager _tokenManager = TokenManager();
  final JwtUtils _jwtUtils = JwtUtils();
  final NotificationService _notificationService = NotificationService();
  final Logger _logger = Logger();

  /// Initiates OAuth flow for the given provider
  /// Returns the URL to be opened in a WebView or browser
  // In your OAuthService class, modify the initiateOAuth method:
  Future<String?> initiateOAuth({
    required String provider,
    required String redirectUrl,
    required Map<String, dynamic> additionalParams
  }) async {
    try {
      _logger.i('Initiating OAuth flow for provider: $provider');

      // For Google auth, add specific parameters to show account chooser
      final response = await _apiClient.initiateOAuth(
        provider: provider,
        redirectUrl: redirectUrl,
        additionalParams: additionalParams,
      );

      if (response.statusCode == 200) {
        final authUrl = response.data['authUrl'];
        _logger.i('OAuth auth URL generated: $authUrl');
        return authUrl;
      } else {
        _logger.e('Failed to initiate OAuth: ${response.statusCode}');
        _notificationService.showError('Failed to initiate authentication');
        return null;
      }
    } catch (e) {
      _logger.e('Error initiating OAuth: $e');
      _notificationService.showError('Authentication failed');
      return null;
    }
  }

  /// Complete OAuth flow using WebView with improved redirect URL handling

  Future<bool> completeOAuthFlow({
    required String provider,
    String? callbackUrlScheme,
  }) async {
    try {
      _logger.i('Starting complete OAuth flow for provider: $provider');

      // Define redirect URL that Supabase expects
      const redirectUrl = 'http://localhost:3000';

      // 1. Get authorization URL from backend with improved params for Google
      Map<String, dynamic> additionalParams = {};
      if (provider.toLowerCase() == 'google') {
        // These parameters help with account selection screen and security
        additionalParams = {
          'prompt': 'select_account', // Force account chooser
          'access_type': 'offline', // Get refresh token
          'include_granted_scopes': 'true',
          'login_hint': '', // You can add a specific email here if you know it
        };
      }

      // Get authorization URL
      final authUrl = await initiateOAuth(
        provider: provider,
        redirectUrl: redirectUrl,
        additionalParams: additionalParams,
      );

      if (authUrl == null) {
        _logger.e('Failed to get OAuth authorization URL');
        _notificationService.showError('Authentication failed');
        return false;
      }

      // 2. Show custom WebView and wait for redirect
      _logger.i('Opening WebView for OAuth authentication');
      final resultUrl = await showAuthWebView(authUrl);

      if (resultUrl == null) {
        _logger.e('WebView closed without authentication result');
        _notificationService.showError('Authentication canceled');
        return false;
      }

      _logger.i('WebView closed with result URL captured');

      // 3. Parse the resulting URL to extract tokens
      return await _handleAuthResultUrl(resultUrl);
    } catch (e, stackTrace) {
      _logger.e('Error completing OAuth flow: $e');
      _logger.e('Stack trace: $stackTrace');
      _notificationService.showError('Authentication failed');
      return false;
    }
  }

  // Improved method to extract tokens from the URL
  Future<bool> _handleAuthResultUrl(String url) async {
    _logger.i('Processing authentication result URL');

    try {
      // Extract fragment or query part from URL
      Map<String, String> params = {};

      // Check for fragment part first (most common with OAuth implicit flow)
      if (url.contains('#')) {
        final fragmentPart = url.split('#')[1];
        _logger.i('Found fragment in URL');
        params = Uri.splitQueryString(fragmentPart);
      }
      // Then check for query parameters
      else if (url.contains('?')) {
        final queryPart = url.split('?')[1];
        params = Uri.splitQueryString(queryPart);
      }
      // If no obvious delimiter, try to extract based on localhost:3000
      else if (url.contains('localhost:3000')) {
        final parts = url.split('localhost:3000');
        if (parts.length > 1 && parts[1].isNotEmpty) {
          // Remove any leading / or # characters
          String paramPart = parts[1].replaceFirst(RegExp(r'^[/#]+'), '');
          params = Uri.splitQueryString(paramPart);
        }
      }

      // Log found parameters (without exposing sensitive values)
      _logger.i('Found parameters: ${params.keys.join(', ')}');

      // Extract tokens
      final accessToken = params['access_token'];
      final refreshToken = params['refresh_token'];
      final expiresIn = params['expires_in'];
      final expiresAt = params['expires_at'];
      final providerToken = params['provider_token'];
      final tokenType = params['token_type'] ?? 'bearer';

      if (accessToken == null) {
        _logger.e('No access token found in URL');
        _notificationService.showError('Authentication failed');
        return false;
      }

      _logger.i('Successfully extracted access token');

      // Save all tokens securely
      await _tokenManager.saveUserData('access_token', accessToken);
      await _tokenManager.saveUserData('token_type', tokenType);

      if (refreshToken != null) {
        await _tokenManager.saveUserData('refresh_token', refreshToken);
      }
      if (providerToken != null) {
        await _tokenManager.saveUserData('provider_token', providerToken);
      }

      // Handle token expiration
      if (expiresAt != null) {
        await _tokenManager.saveUserData('expires_at', expiresAt);
      } else if (expiresIn != null) {
        final expirationTime =
            DateTime.now()
                .add(Duration(seconds: int.tryParse(expiresIn) ?? 3600))
                .toIso8601String();
        await _tokenManager.saveUserData('expires_at', expirationTime);
      } else {
        // Default expiration if none provided
        final defaultExpiration =
            DateTime.now().add(const Duration(hours: 1)).toIso8601String();
        await _tokenManager.saveUserData('expires_at', defaultExpiration);
      }

      // Extract user data from JWT
      final jwtData = _jwtUtils.extractJwtData(accessToken);
      if (jwtData != null) {
        _logger.i('Successfully decoded JWT data');

        // Save user ID
        if (jwtData['sub'] != null) {
          await _tokenManager.saveUserData(
            'user_id',
            jwtData['sub'].toString(),
          );
        }

        // Save email
        if (jwtData['email'] != null) {
          await _tokenManager.saveUserData(
            'user_email',
            jwtData['email'].toString(),
          );
        }

        // Save additional user metadata if available
        if (jwtData.containsKey('user_metadata')) {
          try {
            final metadata = jwtData['user_metadata'];
            if (metadata is Map) {
              // You might want to save specific fields from metadata
              if (metadata.containsKey('full_name')) {
                await _tokenManager.saveUserData(
                  'user_name',
                  metadata['full_name'].toString(),
                );
              }

              if (metadata.containsKey('avatar_url')) {
                await _tokenManager.saveUserData(
                  'avatar_url',
                  metadata['avatar_url'].toString(),
                );
              }
            }
          } catch (e) {
            _logger.w('Error processing user metadata: $e');
            // Non-critical, continue with login
          }
        }
      }

      _logger.i('OAuth authentication completed successfully');
      _notificationService.showSuccess('Successfully signed in');
      return true;
    } catch (e, stackTrace) {
      _logger.e('Error processing authentication result: $e');
      _logger.e('Stack trace: $stackTrace');
      _notificationService.showError('Authentication failed');
      return false;
    }
  }


  /// Direct sign-in with OAuth provider token
  Future<bool> signInWithProviderToken({
    required String provider,
    required String providerToken,
  }) async {
    try {
      _logger.i('Signing in with provider token for: $provider');

      final response = await _apiClient.signInWithProviderToken(
        provider: provider,
        providerToken: providerToken,
      );

      if (response.statusCode == 200) {
        // Save tokens
        await _tokenManager.saveSessionData(response.data['session']);
        return true;
      } else {
        _logger.e(
          'Failed to sign in with provider token: ${response.statusCode}',
        );
        _notificationService.showError('Authentication failed');
        return false;
      }
    } catch (e) {
      _logger.e('Error signing in with provider token: $e');
      _notificationService.showError('Authentication failed');
      return false;
    }
  }

  /// Link an existing account with an OAuth provider
  Future<bool> linkOAuthProvider({
    required String provider,
    required String providerToken,
  }) async {
    try {
      _logger.i('Linking account with provider: $provider');

      // Get current user ID
      final userId = await _tokenManager.getUserId();
      if (userId == null) {
        _logger.e('No user ID found, cannot link account');
        _notificationService.showError(
          'You must be logged in to link accounts',
        );
        return false;
      }

      final response = await _apiClient.linkOAuthProvider(
        userId: userId,
        provider: provider,
        providerToken: providerToken,
      );

      if (response.statusCode == 200) {
        _logger.i('Successfully linked $provider account');
        _notificationService.showSuccess('Account linked successfully');
        return true;
      } else {
        _logger.e('Failed to link provider: ${response.statusCode}');
        _notificationService.showError('Failed to link account');
        return false;
      }
    } catch (e) {
      _logger.e('Error linking OAuth provider: $e');
      _notificationService.showError('Failed to link account');
      return false;
    }
  }
}
