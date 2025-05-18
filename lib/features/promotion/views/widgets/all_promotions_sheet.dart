import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/promotion/controller/promotion_controller.dart';
import 'package:store_go/features/promotion/views/widgets/enhanced_promotion_card.dart';
import 'package:store_go/features/promotion/views/widgets/filter_chip_widget.dart';
import 'package:store_go/features/promotion/views/widgets/promotion_details_sheet.dart';


class AllPromotionsSheet extends StatelessWidget {
  final PromotionController controller;

  const AllPromotionsSheet({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final promotions = controller.state.productPromotions;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary(context),
                        borderRadius: BorderRadius.circular(
                          UIConfig.borderRadiusCircular,
                        ),
                      ),
                      child: Text(
                        promotions.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Available Promotions',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.foreground(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChipWidget(label: 'All', isSelected: true),
                      FilterChipWidget(label: 'Percentage', isSelected: false),
                      FilterChipWidget(label: 'Fixed Amount', isSelected: false),
                      FilterChipWidget(label: 'Free Shipping', isSelected: false),
                      FilterChipWidget(label: 'Buy X Get Y', isSelected: false),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: promotions.length,
                  itemBuilder: (context, index) {
                    final promotion = promotions[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: EnhancedPromotionCard(
                        promotion: promotion,
                        onTap: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => PromotionDetailsSheet(
                              promotion: promotion,
                              controller: controller,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}