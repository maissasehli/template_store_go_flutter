import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/controller/controller_form_field_state.dart';

class ResetPasswordController extends GetxController {
  late ControllerFormFieldState newPasswordFieldState;
  late ControllerFormFieldState confirmPasswordFieldState;
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();
  
  Future<void> resetPassword() async {
    if (resetPasswordFormKey.currentState!.validate()) {
      //bool success = await _authService.updatePassword(
      //  newPasswordController.text.trim()
      //);

      //if (success) {
      //  Get.offAllNamed(AppRoute.login);
      //}
    }
  }

  @override
  void onClose() {
    newPasswordFieldState.controller.dispose();
    confirmPasswordFieldState.controller.dispose();
    super.onClose();
  }
}