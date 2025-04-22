import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/review/controllers/review_controller.dart';
import 'package:store_go/features/review/repositories/review_repository.dart';
import 'package:store_go/app/core/services/api_client.dart';

class ProductInfo extends StatelessWidget {
  final Product product;
  final String subtitle;

  const ProductInfo({
    super.key,
    required this.product,
    this.subtitle = '',
  });

  @override
  Widget build(BuildContext context) {
    // Ensure ReviewController is registered as a fallback
    if (!Get.isRegistered<ReviewController>()) {
      print('ProductInfo: ReviewController not found, registering manually');
      Get.put(ApiClient());
      Get.put(ReviewRepository(apiClient: Get.find<ApiClient>()));
      Get.put(ReviewController(repository: Get.find<ReviewRepository>()));
    }

    // Get the ReviewController instance with error handling
    ReviewController? reviewController;
    try {
      reviewController = Get.find<ReviewController>();
    } catch (e) {
      print('ProductInfo: Error finding ReviewController: $e');
      return const Center(
        child: Text(
          'Error: Review service not available',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    // Fetch reviews for this product on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reviewController?.fetchReviews(product.id);
    });

    final bool isInStock = product.stockQuantity > 0;

    return Obx(() {
      // Calculate the average rating dynamically
      double averageRating = reviewController!.reviews.isEmpty
          ? 0
          : reviewController.reviews
                  .map((r) => r.rating)
                  .reduce((a, b) => a + b) /
              reviewController.reviews.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.mutedForeground(context),
              fontSize: 12,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < averageRating.round()
                            ? Icons.star
                            : Icons.star_border,
                        size: 18,
                        color: index < averageRating.round()
                            ? const Color(0xFFFFCC00)
                            : Colors.grey[300],
                      );
                    }),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${reviewController.reviews.length} Review${reviewController.reviews.length == 1 ? '' : 's'})',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: AppColors.mutedForeground(context),
                    ),
                  ),
                ],
              ),
              Text(
                isInStock ? 'Available in stock' : 'Out of stock',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: isInStock ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}