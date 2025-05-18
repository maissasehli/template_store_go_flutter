import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/promotion/controller/promotion_controller.dart';

class PromotionIndicators extends StatelessWidget {
  final PromotionController controller;

  const PromotionIndicators({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final promotions = controller.state.productPromotions;

    if (promotions.length <= 1) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          promotions.length,
          (index) => Obx(() {
            final isActive =
                controller.state.currentPromotionIndex.value == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary(context)
                    : AppColors.muted(context).withOpacity(0.3),
                borderRadius: BorderRadius.circular(
                  UIConfig.borderRadiusCircular,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}