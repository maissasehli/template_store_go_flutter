import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/product/models/product_model.dart';

class EmptyState extends StatelessWidget {
  final Product product;
  final Logger _logger = Logger();

  EmptyState({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 80,
            color: AppColors.muted(context),
          ),
          const SizedBox(height: 24),
          Text(
            'No Reviews Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: AppColors.foreground(context),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Be the first to share your experience',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.mutedForeground(context),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(16),
            width: 280,
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border(context)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: AppColors.muted(context),
                    child:
                        product.images.isNotEmpty
                            ? Image.network(
                              product.images[0],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                _logger.e(
                                  'Error loading product image: $error',
                                );
                                return Icon(
                                  Icons.broken_image,
                                  color: AppColors.mutedForeground(context),
                                );
                              },
                            )
                            : const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: AppColors.primary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
