import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/controller/auth/emailsentcontroller%20.dart';
import 'package:store_go/core/constants/color.dart';
import 'package:store_go/core/constants/imageasset.dart';
import 'package:store_go/view/widgets/auth/customauthbutton.dart';

class EmailSentConfirmation extends GetView<EmailSentController> {
  const EmailSentConfirmation({Key? key}) : super(key: key);

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
              // Email icon with paper plane
              SvgPicture.asset(
                ImageAsset.emailsent,
                height: 120,
                width: 120,
              ),
              SizedBox(height: AppColor.spacingL),
              Text(
                'We Sent you an Email\nto reset your password.',
                style: AppColor.titleMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppColor.spacingXL),
              CustomAuthButton(
                text: 'Return to login',
                onPressed: controller.returnToLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
