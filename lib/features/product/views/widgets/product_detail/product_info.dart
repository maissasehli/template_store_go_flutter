import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/review/controllers/review_controller.dart';
import 'package:store_go/features/review/repositories/review_repository.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class ProductInfo extends StatelessWidget {
  final Product product;
  final String subtitle;

  const ProductInfo({super.key, required this.product, this.subtitle = ''});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ReviewController>()) {
      Get.put(ApiClient());
      Get.put(ReviewRepository(apiClient: Get.find<ApiClient>()));
      Get.put(ReviewController(repository: Get.find<ReviewRepository>()));
    }

    ReviewController? reviewController;
    try {
      reviewController = Get.find<ReviewController>();
    } catch (e) {
      print('ProductInfo: Error finding ReviewController: $e');
      return Center(
        child: Text(
          'product_detail.error_service'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(color: AppColors.destructive(context)),
          ),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      reviewController?.fetchReviews(product.id);
    });

    final bool isInStock = product.stockQuantity > 0;
    final bool isRtl = LocalizationService.isRtl(context);

    return Obx(() {
      double averageRating =
          reviewController!.reviews.isEmpty
              ? 0
              : reviewController.reviews
                      .map((r) => r.rating)
                      .reduce((a, b) => a + b) /
                  reviewController.reviews.length;

      return Column(
        crossAxisAlignment:
            isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: LocalizationService.getLocalizedTextStyle(
              context,
              Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.mutedForeground(context),
              ) ?? TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.mutedForeground(context),
            ),
            ),
          ),
          SizedBox(height: UIConfig.paddingSmall),
          Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Row(
                    textDirection:
                        isRtl ? TextDirection.rtl : TextDirection.ltr,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < averageRating.round()
                            ? Icons.star
                            : Icons.star_border,
                        size: 18,
                        color:
                            index < averageRating.round()
                                ? const Color(0xFFFFCC00)
                                : AppColors.border(context),
                      );
                    }),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '(${reviewController.reviews.length} ${reviewController.reviews.length == 1 ? 'product_detail.reviews'.translate() : 'product_detail.reviews_plural'.translate()})',
                    style: LocalizationService.getLocalizedTextStyle(
                      context,
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.mutedForeground(context),
                      ) ?? TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.mutedForeground(context),
            ),
                    ),
                  ),
                ],
              ),
              Text(
                isInStock
                    ? 'product_detail.available_in_stock'.translate()
                    : 'product_detail.out_of_stock'.translate(),
                style: LocalizationService.getLocalizedTextStyle(
                  context,
                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color:
                        isInStock
                            ? Colors.green
                            : AppColors.destructive(context),
                  ) ?? TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isInStock ? Colors.green : AppColors.destructive(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
