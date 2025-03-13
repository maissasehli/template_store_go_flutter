import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/controller/auth/reset_password.dart';
import 'package:store_go/core/constants/colors.dart';
import 'package:store_go/view/widgets/auth/custom_auth_button.dart';
import 'package:store_go/view/widgets/auth/custom_text_title.dart';
import 'package:store_go/view/widgets/extensions/fields/validated_fields.dart';

class ResetPasswordPage extends StatelessWidget {
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: controller.resetPasswordFormKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppColor.spacingM),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextTitle(text: 'Reset Password'),
                  SizedBox(height: AppColor.spacingL),
                  Text(
                    'Create a new password that is at least 8 characters long.',
                    style: AppColor.bodyMedium,
                  ),
                  SizedBox(height: AppColor.spacingL),
                  
                  // New Password Field
                  "New Password".passwordField(
                    context,
                    fieldState: controller.newPasswordFieldState,
                  ),
                  SizedBox(height: AppColor.spacingM),
                  
                  // Confirm Password Field
                  "Confirm New Password".passwordField(
                    context,
                    fieldState: controller.confirmPasswordFieldState,
                  ),
                  SizedBox(height: AppColor.spacingXL),
                  
                  // Reset Password Button
                  CustomAuthButton(
                    text: 'Reset Password',
                    onPressed: () => controller.resetPassword(),
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