import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    // Validate email and password
    if (_validateInputs()) {
      // Perform login logic here
      // For example:
      // authService.login(email, password)
      print('Login attempt with: ${emailController.text}');
    }
  }

  bool _validateInputs() {
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return false;
    }
    if (passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your password');
      return false;
    }
    // Add more complex validation if needed
    return true;
  }

  @override
  void onClose() {
    // Clean up controllers
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}