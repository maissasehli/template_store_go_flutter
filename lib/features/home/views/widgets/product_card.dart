import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/home/controllers/home_controller.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/home/views/widgets/card_comps/favorite_button.dart';
import 'package:store_go/features/home/views/widgets/card_comps/product_image.dart';
import 'package:store_go/features/home/views/widgets/card_comps/price_display.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function(String) onProductTap;
  final Function(String) onFavoriteTap;
  final double width;
  final double height;

  const ProductCard({
    super.key,
    required this.product,
    required this.onProductTap,
    required this.onFavoriteTap,
    this.width = double.infinity,
    this.height = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    return GestureDetector(
      onTap: () => onProductTap(product.id),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.productCard(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border(context), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ProductImage(product: product),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Obx(() {
                      final isFavorite = homeController.isProductInWishlist(
                        product.id,
                      );
                      return FavoriteButton(
                        isFavorite: isFavorite,
                        onTap: () => homeController.toggleFavorite(product.id),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.foreground(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  PriceDisplay(
                    price: product.price,
                    hasDiscount: product.id == '2',
                    originalPrice: 100.00,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}