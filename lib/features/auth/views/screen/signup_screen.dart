import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/features/auth/controllers/signup_controller.dart';
import 'package:store_go/app/core/theme/colors.dart';
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
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.background(context),
          appBar: AppBar(
            backgroundColor: AppColors.background(context),
            leading: IconButton(
              icon: ThemeAwareSvg(
                assetPath: AssetConfig.backArrow,
                height: 24,
                width: 24,
              ),
              onPressed: () => Get.back(),
            ),
            elevation: 0,
          ),
          body: SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return Form(
                key: controller.signupFormKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppColor.spacingM,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        const Text('Create Account').heading3(context),
                        const SizedBox(height: 20),
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
                        const Text(
                          'Continue',
                        ).primaryButton(context, onPressed: controller.signUp),
                        const SizedBox(height: 20), // Already have account row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: AppColors.primary(context),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
