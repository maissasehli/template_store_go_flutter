import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/shared/controllers/controller_form_field_state.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/utils/valid_input.dart';
import 'package:store_go/features/auth/services/auth_service.dart';

class LoginController extends GetxController {
  late ControllerFormFieldState emailFieldState;
  late ControllerFormFieldState passwordFieldState;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();
  final RxBool isLoading = false.obs;

  // Keep track of whether controllers have been disposed
  bool isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Only initialize if they haven't been disposed or aren't initialized yet
    emailFieldState = ControllerFormFieldState(
      controller: TextEditingController(),
      validator: (val) => validInput(val!, 5, 100, "email"),
    );

    passwordFieldState = ControllerFormFieldState(
      controller: TextEditingController(),
      validator: (val) => validInput(val!, 8, 30, "password"),
    );

    isDisposed = false;
  }

  bool validateForm() {
    // Prevent validation if controllers are disposed
    if (isDisposed) return false;

    // Touch all fields to trigger validation
    emailFieldState.touch();
    passwordFieldState.touch();

    // Check if all fields are valid
    return emailFieldState.error == null && passwordFieldState.error == null;
  }

  void login() async {
    // Don't proceed if controllers are disposed
    if (isDisposed) return;

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
    _disposeControllers();
    super.onClose();
  }

  void _disposeControllers() {
    if (!isDisposed) {
      emailFieldState.dispose();
      passwordFieldState.dispose();
      isDisposed = true;
    }
  }

  // Add this method to handle re-initialization if needed
  void reinitializeIfNeeded() {
    if (isDisposed) {
      _initializeControllers();
    }
  }
}
