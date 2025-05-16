import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

class AddToCartButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double price;
  final String buttonText;

  const AddToCartButton({
    super.key,
    required this.onPressed,
    required this.price,
    this.buttonText = 'Add to Panier',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    
    return Row(
      children: [
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.foreground(context),
          ),
        ),
        const SizedBox(width: UIConfig.paddingMedium),
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: AppColors.primaryForeground(context),
              padding: const EdgeInsets.symmetric(vertical: UIConfig.paddingMedium),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 16,
                  color: AppColors.primaryForeground(context),
                ),
                const SizedBox(width: UIConfig.paddingSmall),
                Text(
                  buttonText,
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryForeground(context),
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