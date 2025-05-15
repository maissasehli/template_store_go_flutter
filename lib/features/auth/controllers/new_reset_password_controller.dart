import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/utils/valid_input.dart';
import 'package:store_go/app/shared/controllers/controller_form_field_state.dart';
import 'package:store_go/features/auth/services/auth_service.dart';

class NewResetPasswordController extends GetxController {
  late ControllerFormFieldState newPasswordFieldState;
  late ControllerFormFieldState confirmPasswordFieldState;
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final RxBool isLoading = false.obs;

  late String userId;
  late String email;

  @override
  void onInit() {
    super.onInit();

    // Get userId from arguments
    if (Get.arguments != null) {
      userId = Get.arguments['userId'] ?? '';
      email = Get.arguments['email'] ?? '';
    } else {
      userId = '';
      email = '';
      Get.back();
    }

    // Initialize password fields
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
      isLoading.value = true;
      try {
        final success = await _authService.resetPassword(
          userId,
          newPasswordFieldState.controller.text.trim(),
        );

        if (success) {
          Get.offAllNamed(AppRoute.login);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    newPasswordFieldState.controller.dispose();
    confirmPasswordFieldState.controller.dispose();
    super.onClose();
  }
}
