import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

class PriceDisplay extends StatelessWidget {
  final double price;
  final bool hasDiscount;
  final double? originalPrice;

  const PriceDisplay({
    super.key,
    required this.price,
    this.hasDiscount = false,
    this.originalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.foreground(context),
          ),
        ),
        if (hasDiscount && originalPrice != null)
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              '\$${originalPrice!.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.mutedForeground(context),
                decoration: TextDecoration.lineThrough,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
