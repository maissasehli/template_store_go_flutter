import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes_constants.dart';
import 'package:store_go/core/services/auth_service.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();
  final RxBool isLoading = false.obs;

  void login() async {
    try {
      if (loginFormKey.currentState!.validate()) {
        isLoading.value = true;
        
        final success = await _authService.signIn(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        // if success is true, navigate to home screen
        if (success) {
          Get.offAllNamed(AppRoute.home);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignup() {
    Get.toNamed(AppRoute.signup);
  }

  void goToForgetPassword() {
    Get.toNamed(AppRoute.forgetPassword);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
