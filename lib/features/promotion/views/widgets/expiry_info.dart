import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/promotion/models/promotion_model.dart';

class ExpiryInfo extends StatelessWidget {
  final Promotion promotion;

  const ExpiryInfo({Key? key, required this.promotion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final daysLeft = promotion.endDate.difference(DateTime.now()).inDays;
    final isUrgent = daysLeft <= 3;

    return Row(
      children: [
        Icon(
          Icons.timer_outlined,
          size: 12,
          color: isUrgent ? Colors.red : AppColors.mutedForeground(context),
        ),
        const SizedBox(width: 4),
        Text(
          daysLeft > 0 ? 'Expires in $daysLeft days' : 'Expires today!',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isUrgent ? Colors.red : AppColors.mutedForeground(context),
                fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal,
              ),
        ),
        if (promotion.couponCode != null &&
            promotion.couponCode!.isNotEmpty) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(UIConfig.borderRadiusSmall),
              border: Border.all(
                color: AppColors.primary(context).withOpacity(0.2),
              ),
            ),
            child: Text(
              promotion.couponCode!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary(context),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
            ),
          ),
        ],
      ],
    );
  }
}