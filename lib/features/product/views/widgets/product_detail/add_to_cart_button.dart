import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class AddToCartButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double price;
  final String? buttonText;

  const AddToCartButton({
    super.key,
    required this.onPressed,
    required this.price,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bool isRtl = LocalizationService.isRtl(context);

    return Row(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: LocalizationService.getLocalizedTextStyle(
            context,
            textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.foreground(context),
            ) ?? TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.foreground(context),
            ),
          ),
        ),
        const SizedBox(width: UIConfig.paddingMedium),
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: AppColors.primaryForeground(context),
              padding: const EdgeInsets.symmetric(
                vertical: UIConfig.paddingMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  UIConfig.borderRadiusCircular,
                ),
              ),
            ),
            child: Row(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 16,
                  color: AppColors.primaryForeground(context),
                ),
                const SizedBox(width: UIConfig.paddingSmall),
                Text(
                  buttonText ?? 'product_detail.add_to_cart'.translate(),
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryForeground(context),
                    ) ?? TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryForeground(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
