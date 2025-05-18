import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/promotion/controller/promotion_controller.dart';
import 'package:store_go/features/promotion/models/promotion_model.dart';
import 'package:store_go/features/promotion/utils/promotion_utils.dart';
import 'package:store_go/features/promotion/views/widgets/detail_card.dart';
import 'package:store_go/features/promotion/views/widgets/enhanced_promotion_card.dart';
import 'package:store_go/features/promotion/views/widgets/info_row.dart';
import 'package:store_go/features/promotion/views/widgets/remaining_days_indicator.dart';


class PromotionDetailsSheet extends StatelessWidget {
  final Promotion promotion;
  final PromotionController controller;

  const PromotionDetailsSheet({
    Key? key,
    required this.promotion,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(UIConfig.borderRadiusLarge),
              topRight: Radius.circular(UIConfig.borderRadiusLarge),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.muted(context).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(
                    UIConfig.borderRadiusCircular,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: getPromotionColor(promotion).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          UIConfig.borderRadiusLarge,
                        ),
                        border: Border.all(
                          color: getPromotionColor(promotion).withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            getPromotionIcon(promotion),
                            size: 16,
                            color: getPromotionColor(promotion),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            getPromotionTag(promotion),
                            style: TextStyle(
                              color: getPromotionColor(promotion),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Promotion Details',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.foreground(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EnhancedPromotionCard(
                          promotion: promotion,
                          onTap: () {},
                        ),
                        const SizedBox(height: 24),
                        Text(
                          promotion.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.foreground(context),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          promotion.description ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.mutedForeground(context),
                          ),
                        ),
                        const SizedBox(height: 24),
                        DetailCard(
                          title: 'Promotion Period',
                          icon: Icons.date_range_rounded,
                          child: Column(
                            children: [
                              InfoRow(
                                label: 'Valid from:',
                                value: formatDate(promotion.startDate),
                                icon: Icons.calendar_today_rounded,
                              ),
                              const SizedBox(height: 8),
                              const Divider(),
                              const SizedBox(height: 8),
                              InfoRow(
                                label: 'Valid until:',
                                value: formatDate(promotion.endDate),
                                icon: Icons.event_rounded,
                              ),
                              const SizedBox(height: 16),
                              RemainingDaysIndicator(promotion: promotion),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        DetailCard(
                          title: 'Usage Statistics',
                          icon: Icons.bar_chart_rounded,
                          child: Column(
                            children: [
                              InfoRow(
                                label: 'Used:',
                                value: '${promotion.usageCount} times',
                                icon: Icons.people_alt_rounded,
                              ),
                              const SizedBox(height: 8),
                              InfoRow(
                                label: 'Minimum purchase:',
                                value:
                                    '\$${promotion.minimumPurchase.toStringAsFixed(2)}',
                                icon: Icons.shopping_cart_rounded,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        DetailCard(
                          title: 'Terms & Conditions',
                          icon: Icons.gavel_rounded,
                          child: Text(
                            getTermsText(promotion),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.mutedForeground(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (promotion.couponCode != null &&
                  promotion.couponCode!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        'Copied!',
                        'Coupon code ${promotion.couponCode} copied to clipboard',
                        snackPosition: SnackPosition.BOTTOM,
                        margin: const EdgeInsets.all(UIConfig.paddingMedium),
                        borderRadius: UIConfig.borderRadiusMedium,
                        duration: const Duration(seconds: 2),
                        backgroundColor: AppColors.primary(context).withOpacity(0.9),
                        colorText: Colors.white,
                        icon: const Icon(
                          Icons.copy_rounded,
                          color: Colors.white,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary(context),
                      foregroundColor: AppColors.primaryForeground(context),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          UIConfig.borderRadiusLarge,
                        ),
                      ),
                      elevation: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.copy_rounded, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Copy Code: ${promotion.couponCode}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}