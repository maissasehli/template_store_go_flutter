import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/controller/auth/emailsentcontroller_resetpassword.dart';
import 'package:store_go/core/constants/color.dart';
import 'package:store_go/core/constants/imageasset.dart';

class EmailSentConfirmationResetPassword extends GetView<EmailSentControllerResetPassword> {
  const EmailSentConfirmationResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

     if (Get.isRegistered<EmailSentControllerResetPassword>() == false) {

      Get.put(EmailSentControllerResetPassword());
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
  height: 250,
  width: 250,
  
),

              const SizedBox(height: 5),

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
      backgroundColor: AppColor.secondaryColor, // Black background
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColor.globalBorderRadius), // 50 radius
      ),
    ),
    child: Text(
      'Return to Login',
      style: AppColor.bodyLarge.copyWith(
        color: AppColor.primaryColor, // White text
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
)
            ],
          ),
        ),
      ),
    );
  }
}