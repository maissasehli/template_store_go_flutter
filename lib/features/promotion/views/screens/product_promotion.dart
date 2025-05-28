import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/promotion/controller/promotion_controller.dart';
import 'package:store_go/features/promotion/views/widgets/product_promotion_card.dart';

class ProductPromotionView extends StatefulWidget {
  final String productId;
  final PromotionController controller;

  const ProductPromotionView({
    super.key,
    required this.productId,
    required this.controller,
  });

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
  void didUpdateWidget(ProductPromotionView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the product ID changes, reinitialize promotions
    if (oldWidget.productId != widget.productId) {
      _hasInitializedPromotions = false;
      _initializePromotions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Debug log to see current state
      if (widget.controller.state.isLoading.value) {
        return const ProductPromotionCardSkeleton();
      } else if (widget.controller.state.hasError.value) {
        return _buildErrorWidget();
      } else if (widget.controller.state.productPromotions.isEmpty) {
        return const SizedBox.shrink();
      } else {
        return ProductPromotionCard(
          promotions: widget.controller.state.productPromotions,
          onPromotionTap: (promotion) {
            widget.controller.setSelectedPromotion(promotion);
            widget.controller.openPromotionSheet();
          },
        );
      }
    });
  }

  Widget _buildErrorWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[600], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Unable to load promotions',
              style: TextStyle(color: Colors.red[700], fontSize: 12),
            ),
          ),
          TextButton(
            onPressed: () => _retryLoadPromotions(),
            child: Text('Retry', style: TextStyle(color: Colors.red[700])),
          ),
        ],
      ),
    );
  }

  void _initializePromotions() {
    if (!_hasInitializedPromotions && widget.productId.isNotEmpty) {
      _hasInitializedPromotions = true;
      print('Initializing promotions for product: ${widget.productId}');
      widget.controller.fetchPromotionsByProductId(widget.productId);
    }
  }

  void _retryLoadPromotions() {
    _hasInitializedPromotions = false;
    _initializePromotions();
  }
}