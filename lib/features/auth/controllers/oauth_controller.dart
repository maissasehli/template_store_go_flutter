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
        Get.offAllNamed(
          AppRoute.mainContainer,
        ); // Using mainContainer as in login method
      } else {
        _logger.e('OAuth sign-in failed');
      }
    } catch (e) {
      _logger.e('Error during OAuth sign-in: $e');
    } finally {
      isLoading.value = false; // Reset loading regardless of outcome
    }
  }
}
