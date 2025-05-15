import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/shared/controllers/controller_form_field_state.dart';
import 'package:store_go/app/core/utils/valid_input.dart';

class ForgetPasswordController extends GetxController {
  late ControllerFormFieldState emailFieldState;
  final GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    emailFieldState = ControllerFormFieldState(
      controller: TextEditingController(),
      validator: (val) => validInput(val!, 5, 100, "email"),
    );
  }

  // Modified method to handle password reset
  Future<void> goToEmailSentConfirmation() async {
    if (forgetPasswordFormKey.currentState!.validate()) {
      // Call the resetPassword method from AuthService
      //bool success = await _authService.resetPassword(
      //  emailController.text.trim(),
      //);

      // If password reset is successful, navigate to email sent confirmation
      //if (success) {
      //  Get.toNamed(AppRoute.emailResetPasswordConfirmation);
      //}
    }
  }

  @override
  void onClose() {
    emailFieldState.controller.dispose();
    super.onClose();
  }
}
