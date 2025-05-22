import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/settings/controllers/settings_language_controller.dart';

class SettingsLanguageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String languageCode;
  final IconData icon;
  final bool isSelected;

  const SettingsLanguageCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.languageCode,
    required this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsLanguageController>();

    return GestureDetector(
      onTap: () {
        controller.changeLanguage(context, languageCode);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary(context).withOpacity(0.1)
                  : AppColors.background(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primary(context)
                    : AppColors.muted(context),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? AppColors.primary(context)
                      : AppColors.mutedForeground(context),
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Apply localized text style to title
                  Text(
                    title,
                    style: LocalizationService.getLocalizedTextStyle(
                      context,
                      TextStyle(
                        color: AppColors.foreground(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Apply localized text style to subtitle
                  Text(
                    subtitle,
                    style: LocalizationService.getLocalizedTextStyle(
                      context,
                      TextStyle(
                        color: AppColors.mutedForeground(context),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary(context),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
