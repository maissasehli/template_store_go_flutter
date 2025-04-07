import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

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
    return Row(
      children: [
        // Price
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.foreground(context),
          ),
        ),
        const SizedBox(width: 16),
        // Add to cart button
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AssetConfig.bagIcon,
                  color: AppColors.primaryForeground(context),
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryForeground(context),
                    fontFamily: 'Poppins',
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
