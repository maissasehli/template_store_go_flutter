import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/color.dart';
import 'package:store_go/core/constants/imageasset.dart';
import 'package:store_go/controller/auth/logincontroller.dart';
import 'package:store_go/view/widgets/auth/customtextformauth.dart';
import 'package:store_go/view/widgets/auth/customauthbutton.dart';
import 'package:store_go/view/widgets/auth/customtextbodyauth .dart';
import 'package:store_go/view/widgets/auth/customtexttitle .dart';

class Login extends GetView<LoginController> {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
                ),
                const SizedBox(height: 20),
                CustomTextBodyAuth(
                  controller: controller.passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 40),
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
                _buildSocialLoginButton(
                  icon: ImageAsset.appleIcon,
                  text: 'Continue With Apple',
                  onPressed: () {},
                ),
                const SizedBox(height: 20),
                _buildSocialLoginButton(
                  icon: ImageAsset.googleIcon,
                  text: 'Continue With Google',
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
        padding: const EdgeInsets.symmetric(vertical: 15),
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