import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: UIConfig.paddingSmall, 
        vertical: 4
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.border(context),
        ),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              if (quantity > 1) onQuantityChanged(quantity - 1);
            },
            child: Icon(
              Icons.remove, 
              size: 20, 
              color: AppColors.foreground(context),
            ),
          ),
          SizedBox(width: UIConfig.paddingSmall),
          Text(
            '$quantity',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.foreground(context),
            ),
          ),
          SizedBox(width: UIConfig.paddingSmall),
          GestureDetector(
            onTap: () => onQuantityChanged(quantity + 1),
            child: Icon(
              Icons.add, 
              size: 20, 
              color: AppColors.foreground(context),
            ),
          ),
        ],
      ),
    );
  }
}