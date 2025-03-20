// lib/view/screens/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes_constants.dart';
import 'package:store_go/core/services/auth_service.dart';
import 'package:store_go/core/services/services.dart';
import 'package:store_go/view/widgets/extensions/text_extensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final MyServices myServices = Get.find();
  final AuthService authService = Get.find<AuthService>();

  @override
  void initState() {
    super.initState();
    _checkNavigation();
  }

  Future<void> _checkNavigation() async {
    // Give the splash screen time to display
    await Future.delayed(const Duration(seconds: 1));

    // Check if the user is authenticated
    final isAuthenticated = await authService.isAuthenticated();

    if (isAuthenticated) {
      // If authenticated, redirect to main container screen instead of home directly
      Get.offAllNamed(AppRoute.mainContainer);
    } else if (myServices.sharedPreferences.getString("onboarding") == "1") {
      // If onboarding is completed but not authenticated, redirect to login
      Get.offAllNamed(AppRoute.login);
    } else {
      // If neither, redirect to language selection
      Get.offAllNamed('/');
    }
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
