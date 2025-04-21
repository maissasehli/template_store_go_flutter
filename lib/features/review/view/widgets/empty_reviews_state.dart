// empty_reviews_state.dart
import 'package:flutter/material.dart';
import 'package:store_go/features/product/models/product_model.dart';

class EmptyReviewsState extends StatelessWidget {
  final Product product;

  const EmptyReviewsState({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review_outlined, 
            size: 80, 
            color: Colors.grey[300]
          ),
          const SizedBox(height: 24),
          Text(
            'No Reviews Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Be the first to share your experience',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 40),
          // Product thumbnail reminder
          ProductThumbnail(product: product),
        ],
      ),
    );
  }
}

class ProductThumbnail extends StatelessWidget {
  final Product product;

  const ProductThumbnail({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: 280,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: product.images.isNotEmpty
                  ? Image.network(
                      product.images[0],
                      fit: BoxFit.cover,
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
                PriceDisplay(price: product.price),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PriceDisplay extends StatelessWidget {
  final double price;

  const PriceDisplay({
    super.key,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '\$${price.toStringAsFixed(2)}',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        fontFamily: 'Poppins',
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}