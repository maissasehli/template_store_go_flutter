import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/shared/controllers/controller_form_field_state.dart';
import 'package:store_go/app/core/utils/valid_input.dart';
import 'package:store_go/features/auth/services/auth_service.dart';

class ForgetPasswordController extends GetxController {
  late ControllerFormFieldState emailFieldState;
  final GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailFieldState = ControllerFormFieldState(
      controller: TextEditingController(),
      validator: (val) => validInput(val!, 5, 100, "email"),
    );
  }

  // Method to request OTP for password reset
  Future<void> goToEmailSentConfirmation() async {
    if (forgetPasswordFormKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final email = emailFieldState.controller.text.trim();
        final success = await _authService.requestPasswordResetOTP(email);

        if (success) {
          // Go to OTP verification screen and pass the email
          Get.toNamed(AppRoute.verifyOtp, arguments: {'email': email});
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    emailFieldState.controller.dispose();
    super.onClose();
  }
}
