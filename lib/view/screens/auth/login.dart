import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/color.dart';
import 'package:store_go/core/constants/imageasset.dart';
import 'package:store_go/controller/onboarding/auth/logincontroller.dart';
import 'package:store_go/view/widgets/auth/customtextbodyauth%20.dart';
import 'package:store_go/view/widgets/auth/customtextformauth.dart';
import 'package:store_go/view/widgets/auth/customauthbutton.dart';
import 'package:store_go/view/widgets/auth/customtexttitle%20.dart';

class Login extends GetView<LoginController> {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppColor.spacingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              CustomTextTitle(text: 'log in'),
              SizedBox(height: AppColor.spacingL),

              // Email TextField
              CustomTextFormAuth(
                controller: controller.emailController,
                hintText: 'Email Address',
              ),
              SizedBox(height: AppColor.spacingM),

              // Password TextField
              CustomTextBodyAuth(
                controller: controller.passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              SizedBox(height: AppColor.spacingL),

              // Continue Button
              CustomAuthButton(
                onPressed: controller.login,
                text: 'Continue',
              ),
              SizedBox(height: AppColor.spacingM),

              // Create Account Text
              Text(
                "Don't have an Account? Create One",
                style: AppColor.bodySmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppColor.spacingL),

              // Social Login Buttons
              _buildSocialLoginButton(
                icon: ImageAsset.appleIcon,
                text: 'Continue With Apple',
                onPressed: () {},
              ),
              SizedBox(height: AppColor.spacingS),
              _buildSocialLoginButton(
                icon: ImageAsset.googleIcon,
                text: 'Continue With Google',
                onPressed: () {},
              ),
              SizedBox(height: AppColor.spacingS),
              _buildSocialLoginButton(
                icon: ImageAsset.facebookIcon,
                text: 'Continue With Facebook',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton({
    required String icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey.shade300),
        padding: EdgeInsets.symmetric(vertical: AppColor.spacingM),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 24,
            height: 24,
          ),
          SizedBox(width: AppColor.spacingS),
          Text(
            text,
            style: AppColor.bodyMedium,
          ),
        ],
      ),
    );
  }
}