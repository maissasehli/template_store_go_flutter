
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/features/auth/services/auth_service.dart';
import 'package:store_go/features/profile/views/widgets/profile_main_widgets/profile_menu_item.dart';
import 'package:store_go/features/profile/views/widgets/profile_main_widgets/logout_dialog.dart';

class ProfileMenuSection extends StatelessWidget {
  final AuthService authService;

  const ProfileMenuSection({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileMenuItem(
          icon: AssetConfig.location,
          title: 'Address',
          onTap: () => Get.toNamed('/address'),
        ),
        ProfileMenuItem(
          icon: AssetConfig.receipt,
          title: 'My orders',
          onTap: () => Get.toNamed('/orders'),
        ),
        ProfileMenuItem(
          icon: AssetConfig.receipt,
          title: 'Payments',
          onTap: () => Get.toNamed('/payments'),
        ),
        ProfileMenuItem(
          icon: AssetConfig.notification,
          title: 'Notifications',
          onTap: () => Get.toNamed('/notifications'),
        ),
        ProfileMenuItem(
          icon: AssetConfig.setting,
          title: 'Settings',
          onTap: () => Get.toNamed('/settings'),
        ),
        ProfileMenuItem(
          icon: AssetConfig.Logout,
          title: 'Logout',
          onTap: () => showLogoutDialog(context, authService),
        ),
      ],
    );
  }
}
