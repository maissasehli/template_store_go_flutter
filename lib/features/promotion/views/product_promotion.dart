import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/promotion/controller/promotion_controller.dart';
import 'package:store_go/features/promotion/views/widgets/loading_indicator.dart';
import 'package:store_go/features/promotion/views/widgets/promotion_section.dart';


class ProductPromotionView extends StatelessWidget {
  final String productId;
  final PromotionController controller;

  const ProductPromotionView({
    Key? key,
    required this.productId,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _initializePromotions();

    return Obx(() {
      if (controller.state.isLoading.value) {
        return const LoadingIndicator();
      } else if (controller.state.hasError.value ||
          controller.state.productPromotions.isEmpty) {
        return const SizedBox.shrink();
      } else {
        return PromotionSection(
          controller: controller,
          productId: productId,
        );
      }
    });
  }

  void _initializePromotions() {
    controller.fetchPromotionsByProductId(productId);
  }
}