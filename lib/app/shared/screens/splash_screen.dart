import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/services/storage_service.dart';
import 'package:store_go/features/auth/services/auth_service.dart';
import 'package:store_go/app/shared/extensions/text_extensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final AuthService authService = Get.find<AuthService>();

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

      // Check if user has selected language before
      final hasSelectedLanguage = await StorageService.hasSelectedLanguage();

      if (!hasSelectedLanguage) {
        // First-time user, show language selection
        return Get.offAllNamed(AppRoute.language);
      }

      // Check if user has seen onboarding
      final hasSeenOnboarding = await StorageService.hasSeenOnboarding();

      if (!hasSeenOnboarding) {
        // User has selected language but not completed onboarding
        return Get.offAllNamed(AppRoute.onBoarding);
      }

      // Check if the user is authenticated
      final isAuthenticated = await authService.isAuthenticated();

      if (isAuthenticated) {
        // User is authenticated, go to main app
        return Get.offAllNamed(AppRoute.mainContainer);
      } else {
        // User has completed onboarding but not authenticated
        return Get.offAllNamed(AppRoute.login);
      }
    } catch (e, stackTrace) {
      Logger().e("Error in _checkNavigation: $e");
      Logger().e(stackTrace.toString());
      // Fallback navigation in case of error
      Get.offAllNamed(AppRoute.login);
    }
  }

  // function that logs all storage properties to the console using Logger()
  void _logStorageProperties() async {
    Logger().i("Storage properties:");
    Logger().i(
      "hasSelectedLanguage: ${await StorageService.hasSelectedLanguage()}",
    );
    Logger().i(
      "hasSeenOnboarding: ${await StorageService.hasSeenOnboarding()}",
    );
    Logger().i("isAuthenticated: ${await authService.isAuthenticated()}");
    Logger().i("selectedLanguage: ${await StorageService.getSavedLocale()}");
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
