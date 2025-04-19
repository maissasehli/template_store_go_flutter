import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/wishlist/controllers/wishlist_controller.dart'; // Use WishlistController

class FavoriteButton extends StatelessWidget {
  final String productId;

  const FavoriteButton({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final WishlistController wishlistController = Get.find<WishlistController>();

    return Obx(() {
      final isFavorite = wishlistController.isProductInWishlist(productId);

      return Container(
        width: 35,
        height: 35,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: InkWell(
          onTap: () {
            if (isFavorite) {
              wishlistController.removeFromWishlist(productId);
            } else {
              wishlistController.addToWishlist(productId);
            }
          },
          borderRadius: BorderRadius.circular(17.5),
          child: Center(
            child: SvgPicture.asset(
              AssetConfig.heartIcon,
              width: 18,
              height: 17,
              color: isFavorite
                  ? AppColors.destructive(context)
                  : const Color(0xFF130F26),
            ),
          ),
        ),
      );
    });
  }
}