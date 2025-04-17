import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/widgets/rating_stars.dart';
import 'package:store_go/features/product/models/product_modal.dart';
import 'package:store_go/features/review/model/review_model.dart';

class ProductInfo extends StatelessWidget {
  final Product product;
  final String subtitle;

  const ProductInfo({
    super.key,
    required this.product,
    this.subtitle = 'Vado Odell Dress',
  });

  double _calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    final bool isInStock = product.stockQuantity > 0;
    final double averageRating = _calculateAverageRating(product.reviews);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product title
        Text(
          'Roller Rabbit',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: AppColors.foreground(context),
          ),
        ),

        // Product subtitle
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: AppColors.mutedForeground(context),
            fontSize: 11,
            fontFamily: 'Poppins',
          ),
        ),

        // Rating and available stock
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Rating stars and reviews
            Row(
              children: [
                RatingStars(rating: averageRating), // Use the calculated average rating
                const SizedBox(width: 8),
                Text(
                  '(${product.reviews.length} Reviews)',
                  style: TextStyle(
                    color: AppColors.mutedForeground(context),
                    fontSize: 11,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),

            // Available in stock text
            Text(
              isInStock ? 'Available in stock' : 'Out of stock',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: isInStock ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}