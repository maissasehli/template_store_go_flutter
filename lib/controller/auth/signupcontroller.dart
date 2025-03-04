import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/view/screens/onboarding/userprofilesetupscreen.dart';

class SignupController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signup() {
    // Validate fields
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar('Erreur', 'Veuillez remplir tous les champs');
      return;
    }

    // Perform signup logic
    // TODO: Add actual signup implementation (API call, etc.)
    print('Inscription tentée avec :');
    print('Prénom: ${firstNameController.text}');
    print('Nom: ${lastNameController.text}');
    print('Email: ${emailController.text}');

    // Navigate to UserProfileSetupScreen after successful validation
    goToUserProfileSetup();
  }

  void goToUserProfileSetup() {
    Get.to(() => const UserProfileSetupScreen());
  }

  @override
  void onClose() {
    // Dispose controllers when not needed
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}