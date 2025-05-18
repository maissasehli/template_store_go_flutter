import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/promotion/controller/promotion_controller.dart';
import 'package:store_go/features/promotion/models/promotion_model.dart';
import 'package:store_go/features/promotion/repositories/promotion_repository.dart' show PromotionRepository;
import 'package:store_go/features/promotion/views/widgets/enhanced_promotion_card.dart';
import 'package:store_go/features/promotion/views/widgets/loading_indicator.dart';

class CartPromotionSection extends StatelessWidget {
   final PromotionController promotionController;

  CartPromotionSection({super.key}) 
      : promotionController = Get.put(
          PromotionController(
            promotionRepository: PromotionRepository(apiClient: ApiClient()), // Make sure ApiClient is properly imported and implemented
          ),
        );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
   if (promotionController.state.isLoading.value) {
        return const LoadingIndicator();
      }
      
      final promotions = promotionController.state.productPromotions;
      if (promotions.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Special Offers',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground(context),
                  ),
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: promotions.length,
              itemBuilder: (context, index) {
                final promotion = promotions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: EnhancedPromotionCard(
                    promotion: promotion,
                    onTap: () {
                      promotionController.setSelectedPromotion(promotion);
                      Get.bottomSheet(
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.background(context),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  promotion.name,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.foreground(context),
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  promotion.description ?? '',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.mutedForeground(context),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}