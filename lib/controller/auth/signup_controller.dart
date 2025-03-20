import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/controller/other/controller_form_field_state.dart';
import 'package:store_go/core/constants/routes_constants.dart';
import 'package:store_go/core/functions/valid_input.dart';
import 'package:store_go/core/services/auth_service.dart';

class SignupController extends GetxController {
  late ControllerFormFieldState firstNameFieldState;
  late ControllerFormFieldState lastNameFieldState;
  late ControllerFormFieldState emailFieldState;
  late ControllerFormFieldState passwordFieldState;

  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    firstNameFieldState = ControllerFormFieldState(
      controller: TextEditingController(),
      validator: (val) => validInput(val!, 3, 100, "first name"),
    );

    lastNameFieldState = ControllerFormFieldState(
      controller: TextEditingController(),
      validator: (val) => validInput(val!, 3, 100, "last name"),
    );

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
    firstNameFieldState.touch();
    lastNameFieldState.touch();
    emailFieldState.touch();
    passwordFieldState.touch();
    // Check if all fields are valid
    return firstNameFieldState.error == null &&
        lastNameFieldState.error == null &&
        emailFieldState.error == null &&
        passwordFieldState.error == null;
  }

  void signUp() async {
    try {
      if (signupFormKey.currentState!.validate()) {
        isLoading.value = true;

        final success = await _authService.signUp(
          email: emailFieldState.controller.text.trim(),
          password: passwordFieldState.controller.text.trim(),
          firstName: firstNameFieldState.controller.text.trim(),
          lastName: lastNameFieldState.controller.text.trim(),
        );

        if (success) {
          Get.offNamed(AppRoute.profileSetup);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameFieldState.dispose();
    lastNameFieldState.dispose();
    emailFieldState.dispose();
    passwordFieldState.dispose();
    super.onClose();
  }
}
