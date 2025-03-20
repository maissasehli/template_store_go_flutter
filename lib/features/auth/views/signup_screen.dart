import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/auth/controllers/signup_controller.dart';
import 'package:store_go/app/core/config/theme/colors.dart';
import 'package:store_go/app/core/utils/alert_exit_app.dart';
import 'package:store_go/app/shared/extensions/buttons/primary_button.dart';
import 'package:store_go/app/shared/extensions/fields/validated_fields.dart';
import 'package:store_go/app/shared/extensions/text_extensions.dart';

class Signup extends GetView<SignupController> {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => await alertExitApp(context),
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Obx(
              () => Stack(
                children: [
                  SingleChildScrollView(
                    child: Form(
                      key: controller.signupFormKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppColor.spacingM,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 70),
                            const Text('Create Account').heading2(context),
                            const SizedBox(height: 40),
                            // First Name Field
                            "First name".textField(
                              context,
                              fieldState: controller.firstNameFieldState,
                            ),
                            const SizedBox(height: 20),
                            // Last Name Field
                            "Last name".textField(
                              context,
                              fieldState: controller.lastNameFieldState,
                            ),
                            const SizedBox(height: 20),
                            // Email Field
                            "Email Address".emailField(
                            context,
                              fieldState: controller.emailFieldState,
                            ),
                            const SizedBox(height: 20),
                            // Password Field
                            "Password".passwordField(
                              context,
                              fieldState: controller.passwordFieldState,
                            ),
                            const SizedBox(height: 20),
                            // Signup Button
                            const Text('Continue').primaryButton(
                              context,
                              onPressed: controller.signUp,
                            ),
                            const SizedBox(height: 20),
                            // Forgot Password Link
                            GestureDetector(
                              onTap: () {
                                // TODO: Implement password reset logic
                              },
                              child: Text('Forgot Password? Reset').body(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Loading Indicator
                  if (controller.isLoading.value)
                    const Center(child: CircularProgressIndicator()),
                  // Back Button
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
