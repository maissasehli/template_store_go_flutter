import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConfig.paddingLarge,
          vertical: UIConfig.paddingSmall + 3, // 11 equivalent
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary(context)
                  : AppColors.background(context),
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primary(context)
                    : AppColors.border(context),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              fontFamily: 'Poppins',
              color:
                  isSelected
                      ? AppColors.primaryForeground(context)
                      : AppColors.foreground(context),
              fontWeight: FontWeight.w500,
              fontSize: UIConfig.fontSizeRegular,
            ),
          ),
        ),
      ),
    );
  }
}
