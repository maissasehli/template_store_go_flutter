import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/functions/validinput.dart';
import 'package:store_go/controller/auth/signupcontroller.dart';
import 'package:store_go/core/constants/color.dart';
import 'package:store_go/view/widgets/auth/customauthbutton.dart';
import 'package:store_go/view/widgets/auth/customtextbodyauth%20.dart';
import 'package:store_go/view/widgets/auth/customtextformauth.dart';
import 'package:store_go/core/functions/alertexitapp.dart';
import 'package:store_go/view/widgets/auth/customtexttitle%20.dart';

class Signup extends GetView<SignupController> {
  const Signup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await alertExitApp();
      },
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: SafeArea(
          child: Stack(
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
                        CustomTextFormAuth(
                          controller: controller.firstNameController,
                          hintText: 'First name',
                          validator: (val) => validInput(val!, 2, 50, "username"),
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormAuth(
                          controller: controller.lastNameController,
                          hintText: 'Last name',
                          validator: (val) => validInput(val!, 2, 50, "username"),
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormAuth(
                          controller: controller.emailController,
                          hintText: 'Email Address',
                          validator: (val) => validInput(val!, 5, 100, "email"),
                        ),
                        const SizedBox(height: 20),
                        CustomTextBodyAuth(
                          controller: controller.passwordController,
                          hintText: 'Password',
                          obscureText: true,
                          validator: (val) => validInput(val!, 8, 30, "password"),
                        ),
                        const SizedBox(height: 40),
                        CustomAuthButton(
                          onPressed: controller.goToUserProfileSetup,
                          text: 'Continue',
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Forgot Password? Reset',
                          style: AppColor.bodySmall.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
    );
  }
}
