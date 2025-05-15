import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/profile/controllers/edit_profile_controller.dart';

class SaveButton extends StatelessWidget {
  final EditProfileController controller;
  
  const SaveButton({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342,
      height: 55,
      decoration: BoxDecoration(
        color: AppColors.primary(context),
        borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
      ),
      child: TextButton(
        onPressed: () {
          controller.saveProfile();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: UIConfig.paddingLarge,
            vertical: UIConfig.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
          ),
        ),
        child: Obx(() {
          return controller.isUploading.value
              ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColors.primaryForeground(context),
                  strokeWidth: 2,
                ),
              )
              : Text(
                'Save',
                style: TextStyle(
                  color: AppColors.primaryForeground(context),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              );
        }),
      ),
    );
  }
}