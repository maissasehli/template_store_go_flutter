import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/controllers/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.foreground(context),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.foreground(context)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Appearance'),
                const SizedBox(height: 16),
                _buildThemeToggleCard(context, themeController),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Account'),
                const SizedBox(height: 16),
                _buildSettingsOption(
                  context: context,
                  title: 'Change Password',
                  subtitle: 'Update your password for security',
                  onTap: () => Get.toNamed('/change-password'),
                ),
                _buildSettingsOption(
                  context: context,
                  title: 'Email Preferences',
                  subtitle: 'Manage email notifications',
                  onTap: () => Get.toNamed('/email-preferences'),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'General'),
                const SizedBox(height: 16),
                _buildSettingsOption(
                  context: context,
                  title: 'Language',
                  subtitle: 'Select your preferred language',
                  onTap: () => Get.toNamed('/language'),
                ),
                _buildSettingsOption(
                  context: context,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () => Get.toNamed('/privacy-policy'),
                ),
                _buildSettingsOption(
                  context: context,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms of service',
                  onTap: () => Get.toNamed('/terms-of-service'),
                ),
                _buildSettingsOption(
                  context: context,
                  title: 'About',
                  subtitle: 'App version and information',
                  onTap: () => Get.toNamed('/about'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.mutedForeground(context),
        ),
      ),
    );
  }

  Widget _buildThemeToggleCard(
    BuildContext context,
    ThemeController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  controller.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: AppColors.foreground(context),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.foreground(context),
                      ),
                    ),
                    Text(
                      controller.isDarkMode ? 'Dark Mode' : 'Light Mode',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.mutedForeground(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GetBuilder<ThemeController>(
              builder: (controller) {
                return Switch(
                  value: controller.isDarkMode,
                  onChanged: (value) {
                    controller.toggleTheme();
                  },
                  activeColor: AppColors.primary(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption({
    required BuildContext context,
    required String title,
    required String subtitle,
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
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.foreground(context),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.mutedForeground(context),
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
}
