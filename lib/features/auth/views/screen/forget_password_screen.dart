import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/auth/controllers/forget_password.dart';
import 'package:store_go/features/auth/views/widgets/custom_auth_button.dart';
import 'package:store_go/app/core/theme/colors.dart';
import 'package:store_go/app/shared/extensions/fields/validated_fields.dart';


class ForgetPassword extends StatelessWidget {
  final ForgetPasswordController controller = Get.put(ForgetPasswordController());

  ForgetPassword({super.key});

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
        child: Form( // Add Form widget
          key: controller.forgetPasswordFormKey, // Add form key
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppColor.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Forgot Password',
                  style: AppColor.titleLarge,
                ),
                SizedBox(height: AppColor.spacingL),
                "Enter email address".emailField(
                  context,
                  fieldState: controller.emailFieldState,
                ),
                SizedBox(height: AppColor.spacingXL),
                CustomAuthButton(
                  text: 'Continue',
                  onPressed: () => controller.goToEmailSentConfirmation(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}