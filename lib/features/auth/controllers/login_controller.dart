import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/shared/controllers/controller_form_field_state.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/utils/valid_input.dart';
import 'package:store_go/features/auth/services/auth_service.dart';
import 'package:store_go/app/core/services/storage_service.dart'; // Add this import

class LoginController extends GetxController {
  late ControllerFormFieldState emailFieldState;
  late ControllerFormFieldState passwordFieldState;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  
  // Fix this line to use StorageService
  final StorageService myServices = Get.find<StorageService>();

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
        final response = await _authService.signIn(
          email: emailFieldState.controller.text.trim(),
          password: passwordFieldState.controller.text.trim(),
        );

        print("==================== Controller $response");
        
        if (response) {
          // Access SharedPreferences through StorageService
          StorageService.prefs.setString("step", "1");
          Get.offAllNamed(AppRoute.mainContainer);
        } else {
          Get.defaultDialog(
            title: "Warning",
            middleText: "Email Or Password Not Correct",
          );
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