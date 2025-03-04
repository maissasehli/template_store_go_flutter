import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ForgetPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();

  void resetPassword() {
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }
    
    // Add password reset logic here
    print('Resetting password for: ${emailController.text}');
    // Typically, you would call a service method to send a password reset link
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
