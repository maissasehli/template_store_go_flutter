import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/functions/validinput.dart';
import 'package:store_go/controller/auth/forget_password.controller.dart';
import 'package:store_go/view/widgets/auth/customauthbutton.widgets.dart';
import 'package:store_go/core/constants/color.dart';
import 'package:store_go/view/widgets/auth/customtextformauth.widgets.dart';

class ForgetPassword extends StatelessWidget {
  final ForgetPasswordController controller = Get.put(ForgetPasswordController());

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
                CustomTextFormAuth(
                  controller: controller.emailController,
                  hintText: 'Enter email address',
                  validator: (val) => validInput(val!, 5, 100, "email"), // Add validator
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