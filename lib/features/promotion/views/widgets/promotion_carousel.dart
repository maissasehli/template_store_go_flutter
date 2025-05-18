import 'package:flutter/material.dart';
import 'package:store_go/features/promotion/controller/promotion_controller.dart';
import 'package:store_go/features/promotion/models/promotion_model.dart';
import 'package:store_go/features/promotion/views/widgets/enhanced_promotion_card.dart';
import 'package:store_go/features/promotion/views/widgets/navigation_button.dart';
import 'package:store_go/features/promotion/views/widgets/promotion_details_sheet.dart';


class PromotionCarousel extends StatelessWidget {
  final PromotionController controller;

  const PromotionCarousel({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final promotions = controller.state.productPromotions;

    return Container(
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: PageController(
              initialPage: controller.state.currentPromotionIndex.value,
              viewportFraction: 0.92,
            ),
            onPageChanged: (index) {
              controller.state.currentPromotionIndex.value = index;
            },
            itemCount: promotions.length,
            itemBuilder: (context, index) {
              final promotion = promotions[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: EnhancedPromotionCard(
                  promotion: promotion,
                  onTap: () => _showPromotionDetails(context, promotion),
                ),
              );
            },
          ),
          if (promotions.length > 1) ...[
            Positioned(
              left: 0,
              child: NavigationButton(
                icon: Icons.chevron_left_rounded,
                onTap: () {
                  final currentPage =
                      controller.state.currentPromotionIndex.value;
                  if (currentPage > 0) {
                    controller.state.currentPromotionIndex.value =
                        currentPage - 1;
                  } else {
                    controller.state.currentPromotionIndex.value =
                        promotions.length - 1;
                  }
                },
              ),
            ),
            Positioned(
              right: 0,
              child: NavigationButton(
                icon: Icons.chevron_right_rounded,
                onTap: () {
                  final currentPage =
                      controller.state.currentPromotionIndex.value;
                  if (currentPage < promotions.length - 1) {
                    controller.state.currentPromotionIndex.value =
                        currentPage + 1;
                  } else {
                    controller.state.currentPromotionIndex.value = 0;
                  }
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showPromotionDetails(BuildContext context, Promotion promotion) {
    controller.selectedPromotion.value = promotion;
    controller.openPromotionSheet();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PromotionDetailsSheet(
        promotion: promotion,
        controller: controller,
      ),
    ).then((_) => controller.closePromotionSheet());
  }
}