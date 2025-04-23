import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/wishlist/controllers/wishlist_controller.dart';

class FavoriteButton extends StatelessWidget {
  final String productId;

  const FavoriteButton({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final WishlistController wishlistController = Get.find<WishlistController>();
    // Using a local Rx variable to immediately respond to tap
    final RxBool isFavoriteLocal = RxBool(wishlistController.isProductInWishlist(productId));

    return Obx(() {
      return Container(
        width: 35,
        height: 35,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: InkWell(
          onTap: () {
            // Toggle local state immediately
            final newState = !isFavoriteLocal.value;
            isFavoriteLocal.value = newState;
            
            // Perform the actual operation in the background
            if (newState) {
              wishlistController.addToWishlist(productId).catchError((error) {
                // Revert local state in case of error
                isFavoriteLocal.value = false;
              });
            } else {
              wishlistController.removeFromWishlist(productId).catchError((error) {
                // Revert local state in case of error
                isFavoriteLocal.value = true;
              });
            }
          },
          borderRadius: BorderRadius.circular(17.5),
          child: Center(
            child: SvgPicture.asset(
              AssetConfig.heartIcon,
              width: 18,
              height: 17,
              color: isFavoriteLocal.value
                  ? AppColors.destructive(context)
                  : const Color(0xFF130F26),
            ),
          ),
        ),
      );
    });
  }
}