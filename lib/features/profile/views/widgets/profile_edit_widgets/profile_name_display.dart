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
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.foreground(context),
                  fontWeight: FontWeight.bold,
                ),
          );
        }),
        SizedBox(height: UIConfig.paddingSmall / 2),
        Obx(() {
          final username =
              controller.user.value?.name.split(' ').first.toLowerCase() ??
              'username';
          return Text(
            '@$username',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.muted(context),
                ),
          );
        }),
      ],
    );
  }
}