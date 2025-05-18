import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/promotion/controller/promotion_controller.dart';
import 'package:store_go/features/promotion/views/widgets/all_promotions_sheet.dart';
import 'package:store_go/features/promotion/views/widgets/promotion_carousel.dart';
import 'package:store_go/features/promotion/views/widgets/promotion_indicators.dart';


class PromotionSection extends StatelessWidget {
  final PromotionController controller;
  final String productId;

  const PromotionSection({
    Key? key,
    required this.controller,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Special Offers',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground(context),
                    ),
              ),
              if (controller.state.productPromotions.length > 1)
                TextButton(
                  onPressed: () => _showAllPromotions(context),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                  child: Text(
                    'View all (${controller.state.productPromotions.length})',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary(context),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        PromotionCarousel(controller: controller),
        const SizedBox(height: 12),
        PromotionIndicators(controller: controller),
      ],
    );
  }

  void _showAllPromotions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AllPromotionsSheet(controller: controller),
    );
  }
}