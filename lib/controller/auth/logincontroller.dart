import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  void login() {
    if (loginFormKey.currentState!.validate()) {
      // Perform login logic here
      // For example:
      // authService.login(email, password)
      print('Login attempt with: ${emailController.text}');
    }
  }

  void goToSignup() {
    // Navigation vers la page de signup
    Get.toNamed(AppRoute.signup);
  }

  // New method to navigate to Forget Password screen
  void doToForgetPassword() {
    Get.toNamed(AppRoute.forgetpassword);
  }

  @override
  void onClose() {
    // Clean up controllers
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}