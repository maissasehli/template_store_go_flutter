import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/promotion/models/promotion_model.dart';

class RemainingDaysIndicator extends StatelessWidget {
  final Promotion promotion;

  const RemainingDaysIndicator({Key? key, required this.promotion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalDuration =
        promotion.endDate.difference(promotion.startDate).inDays;
    final remainingDays = promotion.endDate.difference(DateTime.now()).inDays;
    final progress = 1 - (remainingDays / totalDuration);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              remainingDays > 0
                  ? '$remainingDays days remaining'
                  : 'Expires today!',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color:
                    remainingDays <= 3 ? Colors.red : AppColors.primary(context),
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}% elapsed',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.mutedForeground(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.muted(context).withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              remainingDays <= 3 ? Colors.red : AppColors.primary(context),
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}