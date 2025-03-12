import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();



  // Modified method to handle password reset
  Future<void> goToEmailSentConfirmation() async {
    if (forgetPasswordFormKey.currentState!.validate()) {
      // Call the resetPassword method from AuthService
      //bool success = await _authService.resetPassword(
      //  emailController.text.trim(),
      //);

      // If password reset is successful, navigate to email sent confirmation
      //if (success) {
      //  Get.toNamed(AppRoute.emailResetPasswordConfirmation);
      //}
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
