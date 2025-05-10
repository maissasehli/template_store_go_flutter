import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/services/storage_service.dart';
import 'package:store_go/features/auth/services/auth_service.dart';
import 'package:store_go/app/shared/extensions/text_extensions.dart';
import 'package:store_go/features/auth/services/token_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final AuthService authService = Get.find<AuthService>();
  final TokenManager tokenManager = Get.find<TokenManager>();

  @override
  void initState() {
    super.initState();
    _checkNavigation();
    _logStorageProperties();
  }

  Future<void> _checkNavigation() async {
    try {
      // Give the splash screen time to display
      await Future.delayed(const Duration(seconds: 1));

      // Check if user is authenticated AND token is still valid
      final isAuthenticated = await authService.isAuthenticated();
      Logger().d("Checking if user is authenticated: $isAuthenticated");

      if (isAuthenticated) {
        // If authenticated, check if token is valid
        final hasValidToken = await tokenManager.checkAndRefreshTokenIfNeeded();
        Logger().d("Checking if token is valid: $hasValidToken");

        if (hasValidToken) {
          // User is authenticated with valid token, go to main app
          Logger().d(
            "User is authenticated with valid token, going to main container",
          );
          return Get.offAllNamed(AppRoute.mainContainer);
        } else {
          // Token is invalid and couldn't be refreshed
          Logger().d("Token invalid and couldn't be refreshed, going to login");
          return Get.offAllNamed(AppRoute.login);
        }
      }

      // Continue with normal flow for non-authenticated users

      // Check if user has selected language before
      final hasSelectedLanguage = await StorageService.hasSelectedLanguage();
      if (!hasSelectedLanguage) {
        // First-time user, show language selection
        Logger().d("First-time user, showing language selection");
        return Get.offAllNamed(AppRoute.language);
      }

      // Check if user has seen onboarding
      final hasSeenOnboarding = await StorageService.hasSeenOnboarding();
      if (!hasSeenOnboarding) {
        // User has selected language but not completed onboarding
        Logger().d("User needs to complete onboarding");
        return Get.offAllNamed(AppRoute.onBoarding);
      }

      // If we reach here, user is not authenticated but has completed onboarding
      Logger().d("User not authenticated, going to login");
      return Get.offAllNamed(AppRoute.login);
    } catch (e, stackTrace) {
      Logger().e("Error in _checkNavigation: $e");
      Logger().e(stackTrace.toString());
      // Fallback navigation in case of error
      Get.offAllNamed(AppRoute.login);
    }
  }

  // function that logs all storage properties to the console using Logger()

  void _logStorageProperties() async {
    Logger().d("Storage properties:");
    Logger().d(
      "hasSelectedLanguage: ${await StorageService.hasSelectedLanguage()}",
    );
    Logger().d(
      "hasSeenOnboarding: ${await StorageService.hasSeenOnboarding()}",
    );
    Logger().d("isAuthenticated: ${await authService.isAuthenticated()}");
    Logger().d("selectedLanguage: ${await StorageService.getSavedLocale()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your splash screen logo or animation
            const Text("Splash Screen").heading1(context),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
