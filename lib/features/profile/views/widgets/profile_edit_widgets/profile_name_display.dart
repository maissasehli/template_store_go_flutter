import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/profile/controllers/edit_profile_controller.dart';

class ProfileNameDisplay extends StatelessWidget {
  final EditProfileController controller;

  const ProfileNameDisplay({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          return Text(
            controller.user.value?.name ?? 'User Name',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: AppColors.foreground(context),
            ),
          );
        }),
        SizedBox(height: UIConfig.paddingSmall / 2),
        Obx(() {
          return Text(
            controller.user.value?.email ?? 'user@example.com',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.mutedForeground(context),
              fontFamily: 'Poppins',
            ),
          );
        }),
      ],
    );
  }
}
