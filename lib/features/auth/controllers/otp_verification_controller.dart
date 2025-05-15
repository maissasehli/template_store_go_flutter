import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/features/auth/services/auth_service.dart';
import 'package:store_go/features/auth/services/notification_service.dart';

class OtpVerificationController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final NotificationService _notificationService = NotificationService();
  final RxBool isLoading = false.obs;

  late String email;

  @override
  void onInit() {
    super.onInit();
    // Get email from arguments
    if (Get.arguments != null && Get.arguments['email'] != null) {
      email = Get.arguments['email'];
    } else {
      // Default to empty if somehow not provided
      email = '';
      _notificationService.showError('Email not provided');
      Get.back();
    }
  }

  String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'OTP must contain only digits';
    }
    return null;
  }

  Future<void> verifyOtp() async {
    if (otpFormKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final otpCode = otpController.text.trim();
        final result = await _authService.verifyOTPCode(email, otpCode);

        if (result != null && result.containsKey('userId')) {
          // Navigate to reset password screen with userId
          Get.toNamed(
            AppRoute.resetPasswordNew,
            arguments: {'userId': result['userId'], 'email': email},
          );
        } else {
          _notificationService.showError('Invalid OTP code');
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
