import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/promotion/controller/promotion_controller.dart';
import 'package:store_go/features/promotion/views/widgets/loading_indicator.dart';
import 'package:store_go/features/promotion/views/widgets/promotion_section.dart';

class ProductPromotionView extends StatefulWidget {
  final String productId;
  final PromotionController controller;

  const ProductPromotionView({
    Key? key,
    required this.productId,
    required this.controller,
  }) : super(key: key);

  @override
  State<ProductPromotionView> createState() => _ProductPromotionViewState();
}

class _ProductPromotionViewState extends State<ProductPromotionView> {
  bool _hasInitializedPromotions = false;

  @override
  void initState() {
    super.initState();
    _initializePromotions();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.controller.state.isLoading.value) {
        return const LoadingIndicator();
      } else if (widget.controller.state.hasError.value ||
          widget.controller.state.productPromotions.isEmpty) {
        return const SizedBox.shrink();
      } else {
        return PromotionSection(
          controller: widget.controller,
          productId: widget.productId,
        );
      }
    });
  }

  void _initializePromotions() {
    if (!_hasInitializedPromotions) {
      _hasInitializedPromotions = true;
      widget.controller.fetchPromotionsByProductId(widget.productId);
    }
  }
}
