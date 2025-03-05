import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:store_go/core/services/auth_service.dart';
import 'package:store_go/view/screens/auth/emailsentconfirmation.dart';

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
          print('🚦 Navigating to email confirmation');
          _navigateToEmailConfirmation();
        }
      }
    } catch (e) {
      print('❌ Signup Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _navigateToEmailConfirmation() {
    try {
      // Preferred method: Named route
      Get.offNamed(AppRoute.emailsentconfirmation);
    } catch (navError1) {
      print('🚨 Navigation Error 1: $navError1');

      try {
        // Fallback: Direct page navigation
        Get.to(() => const EmailSentConfirmation());
      } catch (navError2) {
        print('🚨 Navigation Error 2: $navError2');

        // Last resort: Context-based navigation
        Navigator.of(Get.context!).pushReplacement(
          MaterialPageRoute(builder: (_) => const EmailSentConfirmation())
        );
      }
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