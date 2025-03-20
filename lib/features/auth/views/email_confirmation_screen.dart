import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/auth/controllers/email_reset_password.dart';
import 'package:store_go/app/core/config/theme/colors.dart';
import 'package:store_go/app/core/config/assets_constants.dart';

class EmailSentConfirmationResetPassword extends StatelessWidget {
  const EmailSentConfirmationResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.find instead of checking and putting
    final controller = Get.put(ResetPasswordController());

    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Paper plane icon
                      Image.asset(
                        ImageAsset.sendMail, // Use a constant from ImageAsset
                        height: 250,
                        width: 250,
                      ),

                      // Verification text
                      Text(
                        'We Sent you an Email\nto reset your password',
                        style: AppColor.headingMedium.copyWith(
                          color: AppColor.inputTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 48),

                      // Return to login button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.returnToLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.secondaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppColor.globalBorderRadius,
                              ),
                            ),
                          ),
                          child: Text(
                            'Return to Login',
                            style: AppColor.bodyLarge.copyWith(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
