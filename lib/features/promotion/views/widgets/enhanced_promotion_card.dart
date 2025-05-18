import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/promotion/models/promotion_model.dart';
import 'package:store_go/features/promotion/utils/promotion_utils.dart';
import 'package:store_go/features/promotion/views/widgets/discount_badge.dart';
import 'package:store_go/features/promotion/views/widgets/expiry_info.dart';

class EnhancedPromotionCard extends StatelessWidget {
  final Promotion promotion;
  final VoidCallback onTap;

  const EnhancedPromotionCard({
    Key? key,
    required this.promotion,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusLarge),
        side: BorderSide(
          color: AppColors.primary(context).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusLarge),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UIConfig.borderRadiusLarge),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                getPromotionColor(promotion).withOpacity(0.15),
                getPromotionColor(promotion).withOpacity(0.05),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              DiscountBadge(promotion: promotion),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      promotion.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.foreground(context),
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      promotion.description ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.mutedForeground(context),
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    ExpiryInfo(promotion: promotion),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.mutedForeground(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}