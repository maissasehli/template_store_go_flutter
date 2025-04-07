import 'package:get/get.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/auth/services/token_manager.dart';
import 'package:store_go/features/auth/services/oauth_service.dart';
import 'package:store_go/features/auth/services/auth_error_handler.dart';
import 'package:store_go/features/auth/services/notification_service.dart';
import 'package:store_go/features/auth/services/auth_api_client.dart';

/// Main authentication service that coordinates all auth functionality
class AuthService {
  final AuthApiClient _apiClient = AuthApiClient();
  final TokenManager _tokenManager = TokenManager();
  final OAuthService _oauthService = OAuthService();
  final NotificationService _notificationService = NotificationService();
  final AuthErrorHandler _errorHandler = AuthErrorHandler();
  final Logger _logger = Logger();

  // Sign up method using secure backend proxy
  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await _apiClient.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        await _tokenManager.saveSessionData(response.data['session']);
        return true;
      }
      return false;
    } catch (e) {
      _logger.e(e.toString());
      _errorHandler.handleSignUpError(e);
      return false;
    }
  }

  // Sign in method using secure backend proxy
  Future<bool> signIn({required String email, required String password}) async {
    try {
      final response = await _apiClient.signIn(
        email: email,
        password: password,
      );

      if (response.statusCode == 200) {
        await _tokenManager.saveSessionData(response.data['session']);
        _notificationService.showSuccess('Successfully logged in');
        return true;
      }
      return false;
    } catch (e) {
      _errorHandler.handleSignInError(e);
      return false;
    }
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      await _apiClient.signOut();
      // Clear local storage
      await _tokenManager.clearAllTokens();
      _logger.i('Log out successful');
      Get.offAllNamed(AppRoute.login);
    } catch (e) {
      _logger.e('Failed to log out: $e');
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await _tokenManager.hasValidAccessToken();
  }

  // Handle OAuth authentication
  Future<bool> authenticateWithOAuth({
    required String provider,
    String? callbackUrlScheme,
  }) async {
    try {
      return await _oauthService.completeOAuthFlow(
        provider: provider,
        callbackUrlScheme: callbackUrlScheme,
      );
    } catch (e) {
      _logger.e('OAuth authentication error: $e');
      _notificationService.showError('Authentication failed');
      return false;
    }
  }

  // Direct sign-in with OAuth provider token
  Future<bool> signInWithProviderToken({
    required String provider,
    required String providerToken,
  }) async {
    try {
      final success = await _oauthService.signInWithProviderToken(
        provider: provider,
        providerToken: providerToken,
      );

      if (success) {
        _notificationService.showSuccess('Successfully signed in');
      }
      return success;
    } catch (e) {
      _errorHandler.handleOAuthError(e);
      return false;
    }
  }

  // Link an existing account with an OAuth provider
  Future<bool> linkOAuthProvider({
    required String provider,
    required String providerToken,
  }) async {
    return await _oauthService.linkOAuthProvider(
      provider: provider,
      providerToken: providerToken,
    );
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
      final hasValidToken = await _tokenManager.checkAndRefreshTokenIfNeeded();
      if (!hasValidToken) {
        // If token is invalid and can't be refreshed, log out
        await _tokenManager.clearAllTokens();
        // If user is on a protected route, redirect to login
        if (!AppRoute.publicRoutes.contains(Get.currentRoute)) {
          Get.offAllNamed(AppRoute.login);
        }
      }
    } catch (e) {
      _logger.e('Error in handleAppResume: $e');
    }
  }
}
