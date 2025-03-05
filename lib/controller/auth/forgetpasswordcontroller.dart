import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes.dart';

class ForgetPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  void goToEmailSentConfirmation() {
    if (forgetPasswordFormKey.currentState!.validate()) {
      // Proceed to email sent confirmation
      Get.toNamed(AppRoute.emailsentconfirmation);
    }
  }

  @override
  void onClose() {
    // Dispose controller
    emailController.dispose();
    super.onClose();
  }
}