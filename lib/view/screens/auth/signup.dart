import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/controller/auth/signup_controller.dart';
import 'package:store_go/core/constants/colors.dart';
import 'package:store_go/core/functions/valid_input.dart';
import 'package:store_go/view/widgets/auth/custom_auth_button.dart';
import 'package:store_go/view/widgets/auth/custom_text_body_auth.dart';
import 'package:store_go/view/widgets/auth/custom_text_form_auth.dart';
import 'package:store_go/view/widgets/auth/custom_text_title.dart';
import 'package:store_go/core/functions/alert_exit_app.dart';

class Signup extends GetView<SignupController> {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await alertExitApp(),
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: SafeArea(
          child: Obx(() => Stack(
            children: [
              SingleChildScrollView(
                child: Form(
                  key: controller.signupFormKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppColor.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 60),
                        CustomTextTitle(text: 'Create Account'),
                        const SizedBox(height: 40),
                        
                        // First Name Field
                        CustomTextFormAuth(
                          controller: controller.firstNameController,
                          hintText: 'First name',
                          validator: (val) => validInput(val!, 2, 50, "username"),
                        ),
                        const SizedBox(height: 20),
                        
                        // Last Name Field
                        CustomTextFormAuth(
                          controller: controller.lastNameController,
                          hintText: 'Last name',
                          validator: (val) => validInput(val!, 2, 50, "username"),
                        ),
                        const SizedBox(height: 20),
                        
                        // Email Field
                        CustomTextFormAuth(
                          controller: controller.emailController,
                          hintText: 'Email Address',
                          validator: (val) => validInput(val!, 5, 100, "email"),
                        ),
                        const SizedBox(height: 20),
                        
                        // Password Field
                        CustomTextBodyAuth(
                          controller: controller.passwordController,
                          hintText: 'Password',
                          obscureText: true,
                          validator: (val) => validInput(val!, 8, 30, "password"),
                        ),
                        const SizedBox(height: 40),
                        
                        // Signup Button
                        CustomAuthButton(
                          onPressed: controller.signUp,
                          text: 'Continue',
                        ),
                        const SizedBox(height: 10),
                        
                        // Forgot Password Link
                        GestureDetector(
                          onTap: () {
                            // TODO: Implement password reset logic
                          },
                          child: Text(
                            'Forgot Password? Reset',
                            style: AppColor.bodySmall.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
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
          )),
        ),
      ),
    );
  }
}