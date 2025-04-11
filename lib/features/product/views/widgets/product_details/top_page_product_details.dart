// top_page_product_details.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/product/controllers/product_detail_controller.dart';
import 'package:store_go/app/shared/widgets/rating_stars.dart';

class TopProductPageDetails extends GetView<ProductDetailControllerImp> {
  const TopProductPageDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product name
        Text(
          controller.product.value?.name ?? 'Unknown Product',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 8),
        
        // Product subtitle/category
        Text(
          controller.product.value?.subtitle ?? 'Product Details',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Rating and review count
        Row(
          children: [
            RatingStars(rating: double.tryParse(controller.product.value?.rating ?? '0') ?? 0),
            const SizedBox(width: 8),
            Text(
              '(${controller.product.value?.reviewCount ?? 0} Reviews)',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Price information
        Obx(() {
          final discountedPrice = controller.getDiscountedPrice();
          final originalPrice = controller.getOriginalPrice();
          final hasDiscount = controller.hasDiscount();
          
          return Row(
            children: [
              Text(
                '\$${discountedPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              if (hasDiscount)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                   // top_page_product_details.dart (continued)
                    '\$${originalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
              
              if (hasDiscount)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${((originalPrice - discountedPrice) / originalPrice * 100).toStringAsFixed(0)}% OFF',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          );
        }),
        
        const SizedBox(height: 16),
        
        // Stock status
        Text(
          controller.isProductInStock()
              ? 'Available in stock'
              : 'Out of stock',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            color: controller.isProductInStock()
                ? Colors.green[700]
                : Colors.red,
          ),
        ),
      ],
    );
  }
}