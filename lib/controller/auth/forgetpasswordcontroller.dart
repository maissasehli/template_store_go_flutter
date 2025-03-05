import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:store_go/core/services/auth_service.dart';

class ForgetPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();
  
  // Create an instance of AuthService
  final AuthService _authService = AuthService();

  // Modified method to handle password reset
  Future<void> goToEmailSentConfirmation() async {
    if (forgetPasswordFormKey.currentState!.validate()) {
      // Call the resetPassword method from AuthService
      bool success = await _authService.resetPassword(
        emailController.text.trim()
      );

      // If password reset is successful, navigate to email sent confirmation
      if (success) {
        Get.toNamed(AppRoute.emailsentconfirmationresetpassword);
      }
      // Error handling is managed within the AuthService
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}