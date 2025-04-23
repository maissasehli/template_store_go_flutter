import 'package:get/get.dart';
import 'package:store_go/app/core/config/app_config.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/services/pusher_service.dart';
import 'package:store_go/features/auth/services/token_manager.dart';
import 'package:store_go/features/auth/services/auth_error_handler.dart';
import 'package:store_go/features/auth/services/notification_service.dart';
import 'package:store_go/features/auth/services/auth_api_client.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // Add this dependency for JWT decoding

/// Main authentication service that coordinates all auth functionality
class AuthService {
  final AuthApiClient _apiClient = AuthApiClient();
  final TokenManager _tokenManager = TokenManager();
  final AuthErrorHandler _errorHandler = AuthErrorHandler();
  final NotificationService _notificationService = NotificationService();
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
      if (response.statusCode != 200) {
        Logger().e("Error during sign in: ${response.data['error']}");
      }
      if (response.statusCode == 200) {
        await _tokenManager.saveSessionData(response.data['session']);
        _notificationService.showSuccess('Successfully logged in');
        // Initialize Pusher
        final pusherService = Get.find<PusherService>();
        final userId = response.data['session']['userId'];
        if (userId == null || userId.toString().isEmpty) {
          Logger().e('No userId provided to initialize Pusher Services');
        } else {
          pusherService.initializePusher(AppConfig.storeId, userId);
        }
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
      final pusherService = Get.find<PusherService>();

      // Use the immediate version instead of the debounced one
      await pusherService.updateUserOnlineStatusImmediate(false);

      // Now proceed with disconnection and signout
      await pusherService.disconnect(skipStatusUpdate: true);
      await _apiClient.signOut();

      // Proceed with sign-out
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

  // Get current user's ID from JWT access token
  Future<String?> getCurrentUserId() async {
    try {
      final accessToken = await _tokenManager.getAccessToken();
      if (accessToken == null) {
        _logger.w('No access token found');
        return null;
      }

      // Decode the JWT to extract user ID
      final decodedToken = JwtDecoder.decode(accessToken);
      final userId = decodedToken['sub']?.toString() ?? decodedToken['id']?.toString();
      if (userId == null) {
        _logger.w('User ID not found in JWT payload');
        return null;
      }

      _logger.i('Retrieved user ID: $userId');
      return userId;
    } catch (e) {
      _logger.e('Error decoding JWT for user ID: $e');
      return null;
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