import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/controller/auth/emailsentcontroller%20.dart';
import 'package:store_go/core/constants/color.dart';
import 'package:store_go/core/constants/imageasset.dart';

class EmailSentConfirmation extends GetView<EmailSentController> {
  const EmailSentConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        print('🌟 EmailSentConfirmation Build Method Called');

     if (Get.isRegistered<EmailSentController>() == false) {
            print('⚠️ EmailSentController not registered, creating now');

      Get.put(EmailSentController());
    }
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Paper plane icon
 Image.asset(
  'assets/icons/email_sent.png', // Use full path
  height: 120,
  width: 120,
  errorBuilder: (context, error, stackTrace) {
    print('🚨 Image Load Error Details: $error');
    return Icon(Icons.error, size: 120, color: Colors.red);
  },
),

              const SizedBox(height: 32),

              // Verification text
              Text(
                'We Sent you an Email\nto Create your Account',
                style: AppColor.headingMedium.copyWith(
                  color: AppColor.textPrimaryColor,
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
                      borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
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
  }
}