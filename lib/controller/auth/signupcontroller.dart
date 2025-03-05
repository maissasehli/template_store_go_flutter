import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:store_go/core/services/auth_service.dart';

class SignupController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final RxBool isLoading = false.obs;

  void signUp() async {
    try {
      if (signupFormKey.currentState!.validate()) {
        isLoading.value = true;

        print('🚀 Signup Process Started');
        print('Email: ${emailController.text.trim()}');

        final success = await _authService.signUp(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
        );

        print('✅ Signup Success: $success');
        if (success) {
          print('🚦 Navigating to Home');
          // Directly navigate to home screen or dashboard
          Get.offNamed(AppRoute.login);
        }
      }
    } catch (e) {
      print('❌ Signup Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}