// product_info_panel.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/features/product/controllers/product_detail_controller.dart';
import 'package:store_go/app/shared/widgets/rating_stars.dart';
import 'package:store_go/features/product/views/widgets/product_details/product_attributes.dart';

class ProductInfoPanel extends StatelessWidget {
  final ProductDetailControllerImp controller;
  
  const ProductInfoPanel({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.42,
      minChildSize: 0.42,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product title and quantity selector
                ProductTitleSection(controller: controller),

                // Product subtitle
                const SizedBox(height: 4),
                Text(
                  controller.product.value?.subtitle?.isNotEmpty == true 
                      ? controller.product.value!.subtitle! 
                      : 'Product details',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                    fontFamily: 'Poppins',
                  ),
                ),

                // Rating and stock
                const SizedBox(height: 8),
                ProductRatingAndStock(controller: controller),

                // Size and color selectors
                const SizedBox(height: 16),
                ProductAttributes(controller: controller),

                // Description section
                const SizedBox(height: 20),
                ProductDescription(controller: controller),

                // Price and add to cart button
                const SizedBox(height: 24),
                PriceAndCartButton(controller: controller),

                // Bottom indicator
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProductTitleSection extends StatelessWidget {
  final ProductDetailControllerImp controller;
  
  const ProductTitleSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title
        Expanded(
          child: Text(
            controller.product.value?.name ?? 'Unknown Product',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(width: 8),

        // Quantity selector
        QuantitySelector(controller: controller),
      ],
    );
  }
}

class QuantitySelector extends StatelessWidget {
  final ProductDetailControllerImp controller;
  
  const QuantitySelector({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus button
          InkWell(
            onTap: controller.decrementQuantity,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '-',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Quantity display
          Obx(() => Text(
            '${controller.quantity.value}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          )),
          // Plus button
          InkWell(
            onTap: controller.incrementQuantity,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductRatingAndStock extends StatelessWidget {
  final ProductDetailControllerImp controller;
  
  const ProductRatingAndStock({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Rating stars and reviews
        Row(
          children: [
            RatingStars(rating: double.tryParse(controller.product.value?.rating ?? '0') ?? 0),
            const SizedBox(width: 8),
            Text(
              '(${controller.product.value?.reviewCount ?? 0} Reviews)',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 11,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),

        // Available stock
        Text(
          controller.isProductInStock()
              ? 'Available in stock'
              : 'Out of stock',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: controller.isProductInStock()
                ? Colors.black
                : Colors.red,
          ),
        ),
      ],
    );
  }
}

class ProductDescription extends StatelessWidget {
  final ProductDetailControllerImp controller;
  
  const ProductDescription({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          controller.product.value?.description ?? 'No description available',
          style: TextStyle(
            color: Colors.grey[700],
            height: 1.5,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

class PriceAndCartButton extends StatelessWidget {
  final ProductDetailControllerImp controller;
  
  const PriceAndCartButton({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Price with Obx
        Obx(() {
          final discountedPrice = controller.getDiscountedPrice();
          final originalPrice = controller.getOriginalPrice();
          final hasDiscount = controller.hasDiscount();
          
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '\$${discountedPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              if (hasDiscount)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '\$${originalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
            ],
          );
        }),
        const SizedBox(width: 16),
        // Add to cart button
        Expanded(
          child: ElevatedButton(
            onPressed: controller.addToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AssetConfig.bagIcon,
                  color: Colors.white,
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}