import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/features/auth/services/auth_service.dart';

class OAuthController extends GetxController {
  final AuthService _authService = AuthService();
  final RxBool isLoading = false.obs;
  final Logger _logger = Logger();

  // Available OAuth providers
  final List<String> availableProviders = ['google', 'apple', 'facebook'];

  // Start OAuth flow for a specific provider
  Future<void> signInWithProvider(String provider) async {
    try {
      _logger.i('Starting OAuth sign-in with provider: $provider');
      isLoading.value = true;

      // Complete the full OAuth flow with WebView
      final success = await _authService.completeOAuthFlow(
        provider: provider,
        callbackUrlScheme: 'com.storego',
      );

      if (success) {
        _logger.i('OAuth sign-in successful, navigating to home');
        Get.offAllNamed(AppRoute.home);
      } else {
        _logger.e('OAuth sign-in failed');
      }
    } catch (e) {
      _logger.e('Error during OAuth sign-in: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Sign in with a provider token (for native SDK integrations)
  Future<void> signInWithProviderToken(String provider, String token) async {
    try {
      _logger.i('Starting OAuth token sign-in with provider: $provider');
      isLoading.value = true;

      final success = await _authService.signInWithProviderToken(
        provider: provider,
        providerToken: token,
      );

      if (success) {
        _logger.i('OAuth token sign-in successful, navigating to home');
        Get.offAllNamed(AppRoute.home);
      } else {
        _logger.e('OAuth token sign-in failed');
      }
    } catch (e) {
      _logger.e('Error during OAuth token sign-in: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Link an existing account with an OAuth provider
  Future<void> linkAccountWithProvider(String provider, String token) async {
    try {
      _logger.i('Linking account with provider: $provider');
      isLoading.value = true;

      final success = await _authService.linkOAuthProvider(
        provider: provider,
        providerToken: token,
      );

      if (success) {
        _logger.i('Account linked successfully');
      } else {
        _logger.e('Account linking failed');
      }
    } catch (e) {
      _logger.e('Error linking account: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
