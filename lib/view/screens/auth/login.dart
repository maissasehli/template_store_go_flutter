import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/controller/auth/googleauth/google_auth_controller.dart';
import 'package:store_go/core/constants/color.dart';
import 'package:store_go/core/constants/imageasset.dart';
import 'package:store_go/core/functions/validinput.dart';
import 'package:store_go/controller/auth/logincontroller.dart';
import 'package:store_go/view/screens/auth/forgetpassword.dart';
import 'package:store_go/view/widgets/auth/customtextformauth.dart';
import 'package:store_go/view/widgets/auth/customauthbutton.dart';
import 'package:store_go/view/widgets/auth/customtextbodyauth .dart';
import 'package:store_go/view/widgets/auth/customtexttitle .dart';

class Login extends GetView<LoginController> {
  Login({Key? key}) : super(key: key);

  // Initialize GoogleAuthController
  final GoogleAuthController _googleAuthController = Get.put(GoogleAuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: controller.loginFormKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppColor.spacingM),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  const CustomTextTitle(text: 'log in'),
                  const SizedBox(height: 40),
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
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: controller.doToForgetPassword,
                      child: Text(
                        'Forgot Password?',
                        style: AppColor.bodySmall.copyWith(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomAuthButton(
                    onPressed: controller.login,
                    text: 'Continue',
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: controller.goToSignup,
                    child: Text(
                      "Don't have an Account? Create One",
                      style: AppColor.bodyMedium.copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'or',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Google Sign-In Button with loading state
                  Obx(() => _buildSocialLoginButton(
                    icon: ImageAsset.googleIcon,
                    text: 'Continue With Google',
                    onPressed: _googleAuthController.isLoading.value 
                      ? null 
                      : () => _googleAuthController.signInWithGoogle(),
                    isLoading: _googleAuthController.isLoading.value,
                  )),
                  const SizedBox(height: 20),
                  _buildSocialLoginButton(
                    icon: ImageAsset.appleIcon,
                    text: 'Continue With Apple',
                    onPressed: () {},
                  ),
                  const SizedBox(height: 20),
                  _buildSocialLoginButton(
                    icon: ImageAsset.facebookIcon,
                    text: 'Continue With Facebook',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton({
    required String icon,
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey.shade300),
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
        ),
      ),
      child: isLoading
          ? CircularProgressIndicator(color: Colors.black)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  icon,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: AppColor.bodyMedium.copyWith(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
    );
  }
}