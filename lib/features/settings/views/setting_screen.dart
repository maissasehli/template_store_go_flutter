import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/theme/app_color_utils.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/controllers/theme_controller.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';

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
          'settings.title'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground(context),
            ),
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: ThemeAwareSvg(
            assetPath:
                LocalizationService.isRtl(context)
                    ? AssetConfig.arrowRight
                    : AssetConfig.arrowLeft,
            height: 24,
            width: 24,
          ),
          onPressed: () => Get.back(),
        ),
        actions: null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'settings.appearance'.translate()),
                const SizedBox(height: 16),
                _buildThemeToggleCard(context, themeController),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'settings.account'.translate()),
                const SizedBox(height: 16),
                _buildSettingsOption(
                  context: context,
                  title: 'settings.change_password.title'.translate(),
                  subtitle: 'settings.change_password.subtitle'.translate(),
                  onTap: () => Get.toNamed('/change-password'),
                ),
                _buildSettingsOption(
                  context: context,
                  title: 'settings.email_preferences.title'.translate(),
                  subtitle: 'settings.email_preferences.subtitle'.translate(),
                  onTap: () => Get.toNamed('/email-preferences'),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'settings.general'.translate()),
                const SizedBox(height: 16),
                _buildSettingsOption(
                  context: context,
                  title: 'settings.language.title'.translate(),
                  subtitle: 'settings.language.subtitle'.translate(),
                  onTap: () => Get.toNamed(AppRoute.settingsLanguage),
                ),
                _buildSettingsOption(
                  context: context,
                  title: 'settings.privacy_policy.title'.translate(),
                  subtitle: 'settings.privacy_policy.subtitle'.translate(),
                  onTap: () => Get.toNamed('/privacy-policy'),
                ),
                _buildSettingsOption(
                  context: context,
                  title: 'settings.terms.title'.translate(),
                  subtitle: 'settings.terms.subtitle'.translate(),
                  onTap: () => Get.toNamed('/terms-of-service'),
                ),
                _buildSettingsOption(
                  context: context,
                  title: 'settings.about.title'.translate(),
                  subtitle: 'settings.about.subtitle'.translate(),
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
        style: LocalizationService.getLocalizedTextStyle(
          context,
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.mutedForeground(context),
          ),
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
                      'settings.theme.title'.translate(),
                      style: LocalizationService.getLocalizedTextStyle(
                        context,
                        TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.foreground(context),
                        ),
                      ),
                    ),
                    Text(
                      controller.isDarkMode
                          ? 'settings.theme.dark_mode'.translate()
                          : 'settings.theme.light_mode'.translate(),
                      style: LocalizationService.getLocalizedTextStyle(
                        context,
                        TextStyle(
                          fontSize: 14,
                          color: AppColors.mutedForeground(context),
                        ),
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
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.foreground(context),
            ),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(fontSize: 14, color: AppColors.mutedForeground(context)),
          ),
        ),
        trailing: ThemeAwareSvg(
          assetPath:
              LocalizationService.isRtl(context)
                  ? AssetConfig.arrowLeft
                  : AssetConfig.arrowRight,
          height: 20,
          width: 20,
          colorName: AppColorName.foreground,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
