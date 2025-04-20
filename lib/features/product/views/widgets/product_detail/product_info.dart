import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/review/model/review_model.dart';

class ProductInfo extends StatelessWidget {
  final Product product;
  final String subtitle;
  final List<Review> reviews; // Add reviews to calculate average rating

  const ProductInfo({
    super.key,
    required this.product,
    this.subtitle = '',
    required this.reviews, // Add reviews as a required parameter
  });

  // Calculate the average rating based on reviews
  double get averageRating {
    if (reviews.isEmpty) return 0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    final bool isInStock = product.stockQuantity > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: TextStyle(
            color: AppColors.mutedForeground(context),
            fontSize: 11,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        // Display rating and stock status on the same line
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Rating (stars and review count)
            Row(
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < averageRating.round()
                          ? Icons.star
                          : Icons.star_border,
                      size: 16,
                      color: index < averageRating.round()
                          ? const Color(0xFFFFCC00) // Gold color for stars
                          : Colors.grey[300],
                    );
                  }),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${reviews.length} Review${reviews.length == 1 ? '' : 's'})',
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'Poppins',
                    color: AppColors.mutedForeground(context),
                  ),
                ),
              ],
            ),
            // Stock status
            Text(
              isInStock ? 'Available in stock' : 'Out of stock',
              style: TextStyle(
                fontSize: 12,
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