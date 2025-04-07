import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/auth/services/auth_service.dart';
import 'package:store_go/features/profile/controllers/profile_controller.dart';
import 'package:store_go/features/profile/services/user_api_service.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});
  AuthService get authService => AuthService();

  @override
  Widget build(BuildContext context) {
    // Make sure controller is initialized
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController(Get.find<UserApiService>()));
    }
    // This is where we apply the SystemUiOverlayStyle
    final brightness = Theme.of(context).brightness;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Make status bar transparent
        statusBarIconBrightness:
            brightness == Brightness.dark
                ? Brightness
                    .light // Light icons for dark theme
                : Brightness.dark, // Dark icons for light theme
        systemNavigationBarColor: AppColors.background(context),
        systemNavigationBarIconBrightness:
            brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            brightness == Brightness.dark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: AppColors.background(context),
        systemNavigationBarIconBrightness:
            brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background(context),
        body: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary(context),
                ),
              );
            }

            if (controller.hasError.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.errorMessage.value,
                      style: TextStyle(color: AppColors.foreground(context)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.refreshUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary(context),
                      ),
                      child: Text(
                        'Retry',
                        style: TextStyle(
                          color: AppColors.primaryForeground(context),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: controller.refreshUserData,
              color: AppColors.primary(context),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // Profile Header Section
                      _buildProfileHeader(context),
                      const SizedBox(height: 24),
                      // Menu Options
                      _buildMenuOptions(context),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // Updated profile header to use actual user data
  Widget _buildProfileHeader(BuildContext context) {
    final user = controller.user.value;

    return Column(
      children: [
        // Profile Image
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              user?.avatar?? "none", // You may want to add a user avatar field later
              width: 100.87,
              height: 100.87,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // User Name and Username
        Center(
          child: Text(
            user?.name ?? 'User',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: AppColors.foreground(context),
            ),
          ),
        ),
        Center(
          child: Text(
            '@${user?.name.toLowerCase().replaceAll(' ', '') ?? 'username'}',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.mutedForeground(context),
              fontFamily: 'Poppins',
            ),
          ),
        ),
        const SizedBox(height: 12),
        // User Details with Edit Button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    user?.name ?? 'User',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.foreground(context),
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Gabarito',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/edit-profile');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary(context),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      minimumSize: const Size(0, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(66.3),
                      ),
                    ),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryForeground(context),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  user?.email ?? 'email@example.com',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.mutedForeground(context),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 4),
              if (user?.gender != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Gender: ${user?.gender}',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.mutedForeground(context),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              if (user?.ageRange != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Age Range: ${user?.ageRange}',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.mutedForeground(context),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuOptions(BuildContext context) {
    return Column(
      children: [
        _buildMenuOption(
          context: context,
          icon: AssetConfig.location,
          title: 'Address',
          onTap: () => Get.toNamed('/address'),
        ),
        _buildMenuOption(
          context: context,
          icon: AssetConfig.receipt,
          title: 'My orders',
          onTap: () => Get.toNamed('/orders'),
        ),
        _buildMenuOption(
          context: context,
          icon: AssetConfig.receipt,
          title: 'Payments',
          onTap: () => Get.toNamed('/payments'),
        ),
        _buildMenuOption(
          context: context,
          icon: AssetConfig.notification,
          title: 'Notifications',
          onTap: () => Get.toNamed('/notifications'),
        ),
        _buildMenuOption(
          context: context,
          icon: AssetConfig.setting,
          title: 'Settings',
          onTap: () => Get.toNamed('/settings'),
        ),
        _buildMenuOption(
          context: context,
          icon: AssetConfig.Logout,
          title: 'Logout',
          onTap: () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  Widget _buildMenuOption({
    required BuildContext context,
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: SvgPicture.asset(
          icon,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            AppColors.mutedForeground(context),
            BlendMode.srcIn,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.foreground(context),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppColors.foreground(context),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
}
