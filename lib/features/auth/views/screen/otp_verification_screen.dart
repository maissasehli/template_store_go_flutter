import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/colors.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/shared/extensions/buttons/primary_button.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/features/auth/controllers/otp_verification_controller.dart';

class OtpVerificationScreen extends StatelessWidget {
  OtpVerificationScreen({super.key});

  final OtpVerificationController controller = Get.put(
    OtpVerificationController(),
  );

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
            key: controller.otpFormKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppColor.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'OTP Verification',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground(context),
                    ),
                  ),
                  SizedBox(height: AppColor.spacingM),
                  Text(
                    'Enter the 6-digit code sent to ${controller.email}',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.mutedForeground(context),
                    ),
                  ),
                  SizedBox(height: AppColor.spacingXL),

                  // OTP input field
                  TextFormField(
                    controller: controller.otpController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 16,
                      color: AppColors.foreground(context),
                    ),
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: '------',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        letterSpacing: 10,
                        color: AppColors.mutedForeground(context),
                      ),
                      filled: true,
                      fillColor: AppColors.input(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppColor.globalBorderRadius,
                        ),
                        borderSide: BorderSide(
                          color: AppColors.border(context),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppColor.globalBorderRadius,
                        ),
                        borderSide: BorderSide(
                          color: AppColors.primary(context),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    validator: controller.validateOtp,
                  ),

                  SizedBox(height: AppColor.spacingXL),

                  // Verify button
                  Obx(
                    () => const Text('Verify OTP').primaryButton(
                      context,
                      isLoading: controller.isLoading.value,
                      onPressed: controller.verifyOtp,
                    ),
                  ),

                  SizedBox(height: AppColor.spacingM),

                  // Resend button
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Return to forget password screen
                        Get.back();
                      },
                      child: Text(
                        'Didn\'t receive the code? Go back and try again',
                        style: TextStyle(
                          color: AppColors.primary(context),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
