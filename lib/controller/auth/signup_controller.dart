import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes_constants.dart';
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

        final success = await _authService.signUp(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
        );

        if (success) {
          Get.offNamed(AppRoute.profileSetup);
        }
      }
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
