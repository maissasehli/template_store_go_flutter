import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:store_go/core/services/authsupabase.service.dart';
import 'package:store_go/view/screens/onboarding/userprofilesetupscreen.dart';

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
          // Naviguer vers la configuration du profil
          Get.offNamed(AppRoute.userprofilesetup);
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
