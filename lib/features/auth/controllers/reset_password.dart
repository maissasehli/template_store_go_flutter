import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/shared/controllers/controller_form_field_state.dart';
import 'package:store_go/app/core/utils/valid_input.dart';

class ResetPasswordController extends GetxController {
  late ControllerFormFieldState emailFieldState;
  late ControllerFormFieldState newPasswordFieldState;
  late ControllerFormFieldState confirmPasswordFieldState;
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();

    // Initialize email field with validation
    emailFieldState = ControllerFormFieldState(
      controller: TextEditingController(),
      validator: (val) => validInput(val!, 5, 100, "email"),
    );

    // Initialize existing password fields
    newPasswordFieldState = ControllerFormFieldState(
      controller: TextEditingController(),
      validator: (val) => validInput(val!, 8, 30, "password"),
    );

    confirmPasswordFieldState = ControllerFormFieldState(
      controller: TextEditingController(),
      validator: (val) {
        if (val != newPasswordFieldState.controller.text) {
          return 'Passwords do not match';
        }
        return validInput(val!, 8, 30, "password");
      },
    );
  }

  Future<void> resetPassword() async {
    if (resetPasswordFormKey.currentState!.validate()) {
      //bool success = await _authService.updatePassword(
      //  emailFieldState.controller.text.trim(),
      //  newPasswordFieldState.controller.text.trim()
      //);

      //if (success) {
      //  Get.offAllNamed(AppRoute.login);
      //}
    }
  }

  @override
  void onClose() {
    emailFieldState.controller.dispose();
    newPasswordFieldState.controller.dispose();
    confirmPasswordFieldState.controller.dispose();
    super.onClose();
  }
}
