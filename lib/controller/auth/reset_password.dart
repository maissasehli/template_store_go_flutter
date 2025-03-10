import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:store_go/core/services/auth_supabase.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();
  
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    _authService.handlePasswordRecovery();
  }

  Future<void> resetPassword() async {
    if (resetPasswordFormKey.currentState!.validate()) {
      bool success = await _authService.updatePassword(
        newPasswordController.text.trim()
      );

      if (success) {
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