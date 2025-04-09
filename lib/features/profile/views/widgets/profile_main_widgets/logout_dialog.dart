import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/auth/services/auth_service.dart';

void showLogoutDialog(BuildContext context, AuthService authService) {
  Get.dialog(
    AlertDialog(
      backgroundColor: AppColors.card(context),
      title: Text(
        'Logout',
        style: TextStyle(color: AppColors.foreground(context)),
      ),
      content: Text(
        'Are you sure you want to logout?',
        style: TextStyle(color: AppColors.foreground(context)),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Cancel',
            style: TextStyle(color: AppColors.primary(context)),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Implement logout functionality
            authService.signOut();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary(context),
          ),
          child: Text(
            'Logout',
            style: TextStyle(color: AppColors.primaryForeground(context)),
          ),
        ),
      ],
    ),
  );
}
