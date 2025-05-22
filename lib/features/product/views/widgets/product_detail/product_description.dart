import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class ProductDescription extends StatelessWidget {
  final String description;

  const ProductDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    // Don't render anything if description is empty
    if (description.isEmpty) {
      return const SizedBox.shrink();
    }

    final bool isRtl = LocalizationService.isRtl(context);

    return Column(
      crossAxisAlignment:
          isRtl ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          'product_detail.description'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.foreground(context),
            ) ?? TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.foreground(context),
            ),
          ),
        ),
        SizedBox(height: UIConfig.paddingSmall),
        Text(
          description,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.mutedForeground(context),
            ) ?? TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.foreground(context),
            ),
          ),
          textAlign: isRtl ? TextAlign.right : TextAlign.left,
        ),
      ],
    );
  }
}
