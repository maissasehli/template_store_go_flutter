import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/features/auth/services/auth_service.dart';
import 'package:store_go/features/profile/views/widgets/profile_main_widgets/profile_menu_item.dart';
import 'package:store_go/features/profile/views/widgets/profile_main_widgets/logout_dialog.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';

class ProfileMenuSection extends StatelessWidget {
  final AuthService authService;

  const ProfileMenuSection({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileMenuItem(
          icon: AssetConfig.location,
          title: 'profile.address'.translate(),
          onTap: () => Get.toNamed('/address'),
        ),
        ProfileMenuItem(
          icon: AssetConfig.receipt,
          title: 'profile.my_orders'.translate(),
          onTap: () => Get.toNamed('/orders'),
        ),
        ProfileMenuItem(
          icon: AssetConfig.receipt,
          title: 'profile.payments'.translate(),
          onTap: () => Get.toNamed('/payments'),
        ),
        ProfileMenuItem(
          icon: AssetConfig.notification,
          title: 'profile.notifications'.translate(),
          onTap: () => Get.toNamed('/notifications'),
        ),
        ProfileMenuItem(
          icon: AssetConfig.setting,
          title: 'profile.settings'.translate(),
          onTap: () => Get.toNamed('/settings'),
        ),
        ProfileMenuItem(
          icon: AssetConfig.logout,
          title: 'profile.logout'.translate(),
          onTap: () => showLogoutDialog(context, authService),
        ),
      ],
    );
  }
}
