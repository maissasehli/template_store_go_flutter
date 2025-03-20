import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/controllers/controller_form_field_state.dart';
import 'package:store_go/app/core/config/routes_constants.dart';
import 'package:store_go/app/core/utils/valid_input.dart';
import 'package:store_go/features/auth/services/auth_service.dart';

class LoginController extends GetxController {
  late ControllerFormFieldState emailFieldState;
  late ControllerFormFieldState passwordFieldState;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    emailFieldState = ControllerFormFieldState(
      controller: TextEditingController(),
      validator: (val) => validInput(val!, 5, 100, "email"),
    );

    passwordFieldState = ControllerFormFieldState(
      controller: TextEditingController(),
      validator: (val) => validInput(val!, 8, 30, "password"),
    );
  }

  bool validateForm() {
    // Touch all fields to trigger validation
    emailFieldState.touch();
    passwordFieldState.touch();

    // Check if all fields are valid
    return emailFieldState.error == null && passwordFieldState.error == null;
  }

  void login() async {
    try {
      if (validateForm()) {
        isLoading.value = true;

        final success = await _authService.signIn(
          email: emailFieldState.controller.text.trim(),
          password: passwordFieldState.controller.text.trim(),
        );

        if (success) {
          Get.offAllNamed(AppRoute.mainContainer);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignUp() {
    Get.toNamed(AppRoute.signup);
  }

  @override
  void onClose() {
    emailFieldState.dispose();
    passwordFieldState.dispose();
    super.onClose();
  }
}
