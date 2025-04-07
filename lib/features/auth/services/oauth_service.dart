import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/auth/services/auth_api_client.dart';
import 'package:store_go/features/auth/services/jwt_utils.dart';
import 'package:store_go/features/auth/services/token_manager.dart';
import 'package:store_go/features/auth/services/notification_service.dart';

/// Handles OAuth authentication flows
class OAuthService {
  final AuthApiClient _apiClient = AuthApiClient();
  final TokenManager _tokenManager = TokenManager();
  final JwtUtils _jwtUtils = JwtUtils();
  final NotificationService _notificationService = NotificationService();
  final Logger _logger = Logger();

  /// Initiates OAuth flow for the given provider
  /// Returns the URL to be opened in a WebView or browser
  Future<String?> initiateOAuth({
    required String provider,
    required String redirectUrl,
  }) async {
    try {
      _logger.i('Initiating OAuth flow for provider: $provider');

      final response = await _apiClient.initiateOAuth(
        provider: provider,
        redirectUrl: redirectUrl,
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

  /// Complete OAuth flow using WebView
  Future<bool> completeOAuthFlow({
    required String provider,
    String? callbackUrlScheme,
  }) async {
    try {
      _logger.i('Starting complete OAuth flow for provider: $provider');

      // Define redirect URL with custom scheme for mobile app
      final redirectUrl =
          '${callbackUrlScheme ?? 'com.storego'}://oauth-callback';

      // 1. Get authorization URL from backend
      final authUrl = await initiateOAuth(
        provider: provider,
        redirectUrl: redirectUrl,
      );

      if (authUrl == null) {
        _logger.e('Failed to get OAuth authorization URL');
        return false;
      }

      // 2. Open WebView for user authentication
      _logger.i('Opening WebView for OAuth authentication');
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: callbackUrlScheme ?? 'com.storego',
      );

      _logger.i('Got callback URL: $result');

      // 3. Parse the resulting URL
      final uri = Uri.parse(result);

      // Check if we're dealing with an authorization code flow (code in query parameters)
      final code = uri.queryParameters['code'];

      if (code != null) {
        // Handle authorization code flow
        return await _handleAuthorizationCode(code, provider);
      } else {
        // Handle implicit flow (token in URL fragment)
        return await _handleImplicitFlow(uri, provider);
      }
    } catch (e) {
      _logger.e('Error completing OAuth flow: $e');
      _notificationService.showError('Authentication failed');
      return false;
    }
  }

  // Handle authorization code flow
  Future<bool> _handleAuthorizationCode(String code, String provider) async {
    _logger.i('OAuth code received, exchanging for tokens');

    try {
      // Exchange code for tokens
      final response = await _apiClient.exchangeAuthCode(code: code);

      if (response.statusCode == 200) {
        // Save tokens from response
        await _tokenManager.saveSessionData(response.data['session']);
        _notificationService.showSuccess('Successfully signed in');
        return true;
      } else {
        _logger.e('Failed to exchange code for tokens: ${response.statusCode}');
        _notificationService.showError('Authentication failed');
        return false;
      }
    } catch (e) {
      _logger.e('Error exchanging code for tokens: $e');
      _notificationService.showError('Authentication failed');
      return false;
    }
  }

  // Improved handler for implicit flow
  Future<bool> _handleImplicitFlow(Uri uri, String provider) async {
    _logger.i('Handling implicit flow with tokens in fragment');

    // Extract and parse the fragment
    final fragment = uri.fragment;
    if (fragment.isEmpty) {
      _logger.e('No fragment found in callback URL');
      _notificationService.showError('Authentication failed');
      return false;
    }

    // Parse fragment parameters
    final fragmentParams = Uri.splitQueryString(fragment);

    // Extract all tokens
    final accessToken = fragmentParams['access_token'];
    final refreshToken = fragmentParams['refresh_token'];
    final expiresIn = fragmentParams['expires_in'];
    final expiresAt = fragmentParams['expires_at'];
    final providerToken = fragmentParams['provider_token'];

    _logger.i('Access token present: ${accessToken != null}');
    _logger.i('Refresh token present: ${refreshToken != null}');
    _logger.i('Provider token present: ${providerToken != null}');

    if (accessToken == null) {
      _logger.e('No access token found in callback URL fragment');
      _notificationService.showError('Authentication failed');
      return false;
    }

    // Decode the JWT to extract user information
    final jwtData = _jwtUtils.extractJwtData(accessToken);
    String? userId;
    String? email;

    if (jwtData != null) {
      // Extract user ID from common JWT fields
      userId = jwtData['sub'] ?? jwtData['user_id'];
      email = jwtData['email'];

      _logger.i('Extracted user ID: $userId');
      _logger.i('Extracted email: $email');

      // Log other useful information for debugging
      if (jwtData.containsKey('user_metadata')) {
        _logger.i('User metadata present in JWT');
      }

      if (jwtData.containsKey('app_metadata')) {
        _logger.i('App metadata present in JWT');
      }
    } else {
      _logger.w('Could not decode JWT data from access token');
    }

    // Save all the tokens
    await _tokenManager.saveUserData('access_token', accessToken);

    if (refreshToken != null) {
      await _tokenManager.saveUserData('refresh_token', refreshToken);
    }

    // Handle expiration time
    String finalExpiresAt;
    if (expiresAt != null) {
      finalExpiresAt = expiresAt;
    } else if (expiresIn != null) {
      finalExpiresAt = _calculateExpiresAt(expiresIn);
    } else {
      // Default to 1 hour if no expiration info is provided
      finalExpiresAt =
          DateTime.now().add(const Duration(hours: 1)).toIso8601String();
    }

    await _tokenManager.saveUserData('expires_at', finalExpiresAt);

    // Save user ID if available
    if (userId != null) {
      await _tokenManager.saveUserData('user_id', userId);
    }

    // Save email if needed for your application
    if (email != null) {
      await _tokenManager.saveUserData('user_email', email);
    }

    // If we have a provider token, we might want to use it for additional user information
    if (providerToken != null) {
      _logger.i(
        'Provider token found, fetching additional user data if needed',
      );
      try {
        // Depending on your backend setup, you might need to validate or exchange this token
        final success = await signInWithProviderToken(
          provider: provider,
          providerToken: providerToken,
        );

        if (success) {
          _logger.i('Additional provider validation successful');
        }
      } catch (e) {
        _logger.e('Error using provider token: $e');
        // Continue with the flow even if this fails as we already have the main tokens
      }
    }

    _notificationService.showSuccess('Successfully signed in');
    return true;
  }

  // Helper method to calculate expiration time
  String _calculateExpiresAt(String? expiresInStr) {
    final expiresIn = int.tryParse(expiresInStr ?? '3600') ?? 3600;
    final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    return expiresAt.toIso8601String();
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
