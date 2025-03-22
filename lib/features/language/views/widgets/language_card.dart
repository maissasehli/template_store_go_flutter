import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/language/controllers/language_controller.dart';

class LanguageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String languageCode;
  final IconData icon;
  final bool isSelected;

  const LanguageCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.languageCode,
    required this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LanguageController>();

    return InkWell(
      onTap: () => controller.changeLanguage(context,languageCode),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).dividerColor,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color:
                  isSelected
                      ? Theme.of(context).colorScheme.primary
                      : AppColors.foreground(context),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primary
                              : AppColors.foreground(context),
                    ),
                  ),
                  Text(
                    subtitle.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.foreground(context).withValues(alpha: 0.5)
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
