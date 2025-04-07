import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final Function(int) onQuantityChanged;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: AppColors.muted(context),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus button
          InkWell(
            onTap: () {
              if (quantity > 1) {
                onQuantityChanged(quantity - 1);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '-',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.foreground(context),
                ),
              ),
            ),
          ),
          // Quantity display
          Text(
            '$quantity',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.foreground(context),
            ),
          ),
          // Plus button
          InkWell(
            onTap: () {
              onQuantityChanged(quantity + 1);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.foreground(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
