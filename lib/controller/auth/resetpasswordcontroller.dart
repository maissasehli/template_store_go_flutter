import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:store_go/core/services/authsupabase.service.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();
  
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    // Vérifiez si la récupération de mot de passe est valide
    _authService.handlePasswordRecovery();
  }

  Future<void> resetPassword() async {
    if (resetPasswordFormKey.currentState!.validate()) {
      bool success = await _authService.updatePassword(
        newPasswordController.text.trim()
      );

      if (success) {
        // La navigation est déjà gérée dans la méthode updatePassword
        Get.offAllNamed(AppRoute.login);
      }
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}