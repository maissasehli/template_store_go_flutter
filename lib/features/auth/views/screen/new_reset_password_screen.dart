import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/colors.dart';
import 'package:store_go/app/shared/extensions/buttons/primary_button.dart';
import 'package:store_go/app/shared/extensions/fields/validated_fields.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/features/auth/controllers/new_reset_password_controller.dart';

class NewResetPasswordScreen extends StatelessWidget {
  final NewResetPasswordController controller = Get.put(
    NewResetPasswordController(),
  );

  NewResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background(context),
        appBar: AppBar(
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
          child: Form(
            key: controller.resetPasswordFormKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppColor.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground(context),
                    ),
                  ),
                  SizedBox(height: AppColor.spacingS),
                  Text(
                    'Create a new password for your account',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.mutedForeground(context),
                    ),
                  ),
                  SizedBox(height: AppColor.spacingXL),

                  // New password field
                  "New Password".passwordField(
                    context,
                    fieldState: controller.newPasswordFieldState,
                  ),
                  SizedBox(height: AppColor.spacingM),

                  // Confirm password field
                  "Confirm Password".passwordField(
                    context,
                    fieldState: controller.confirmPasswordFieldState,
                  ),

                  SizedBox(height: AppColor.spacingXL),

                  // Reset password button
                  Obx(
                    () => const Text('Reset Password').primaryButton(
                      context,
                      isLoading: controller.isLoading.value,
                      onPressed: controller.resetPassword,
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
