// Section title widget
import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
      child: Align(
        alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          title,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              fontFamily: 'Poppins',
              fontSize: UIConfig.fontSizeMedium,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground(context),
            ),
          ),
        ),
      ),
    );
  }
}
