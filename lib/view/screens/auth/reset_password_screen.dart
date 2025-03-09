import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/controller/auth/reset_password.dart';
import 'package:store_go/core/constants/colors.dart';
import 'package:store_go/core/functions/valid_input.dart';
import 'package:store_go/view/widgets/auth/custom_auth_button.dart';
import 'package:store_go/view/widgets/auth/custom_text_form_auth.dart';
import 'package:store_go/view/widgets/auth/custom_text_title.dart';

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
                  CustomTextFormAuth(
                    controller: controller.newPasswordController,
                    hintText: 'New Password',
                    obscureText: true,
                    validator: (val) => validInput(val!, 8, 30, "password"),
                  ),
                  SizedBox(height: AppColor.spacingM),
                  
                  // Confirm Password Field
                  CustomTextFormAuth(
                    controller: controller.confirmPasswordController,
                    hintText: 'Confirm New Password',
                    obscureText: true,
                    validator: (val) {
                      if (val != controller.newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
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