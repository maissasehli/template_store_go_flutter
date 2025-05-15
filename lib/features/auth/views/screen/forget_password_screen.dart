import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/extensions/buttons/primary_button.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/features/auth/controllers/forget_password.dart';
import 'package:store_go/app/core/theme/colors.dart';
import 'package:store_go/app/shared/extensions/fields/validated_fields.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final ForgetPasswordController controller = Get.put(
    ForgetPasswordController(),
  );

  ForgetPasswordScreen({super.key});
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
            // Add Form widget
            key: controller.forgetPasswordFormKey, // Add form key
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppColor.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground(context),
                    ),
                  ),
                  SizedBox(height: AppColor.spacingL),
                  "Enter email address".emailField(
                    context,
                    fieldState: controller.emailFieldState,
                  ),
                  SizedBox(height: AppColor.spacingXL),
                  const Text('Continue').primaryButton(
                    context,
                    onPressed:
                        controller
                            .goToEmailSentConfirmation, // Call the method to handle password reset
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
