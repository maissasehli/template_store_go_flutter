import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:store_go/core/services/authsupabase.service.dart';

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
          password: passwordController.text.trim()
        );
        
        // Navigation handled in AuthService.signIn method
      }
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignup() {
    Get.toNamed(AppRoute.signup);
  }

  void goToForgetPassword() {
    Get.toNamed(AppRoute.forgetpassword);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}