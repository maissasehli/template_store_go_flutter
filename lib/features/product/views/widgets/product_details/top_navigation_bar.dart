// top_navigation_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/features/product/controllers/product_detail_controller.dart';

class TopNavigationBar extends StatelessWidget {
  const TopNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 24),
              padding: EdgeInsets.zero,
              onPressed: () => Get.back(),
            ),
          ),

          // Cart button
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AssetConfig.panierIcon,
                width: 16,
                height: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  final ProductDetailControllerImp controller;
  
  const FavoriteButton({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: InkWell(
          onTap: controller.toggleFavorite,
          child: Obx(() => Icon(
            controller.product.value?.isFavorite ?? false
                ? Icons.favorite
                : Icons.favorite_border,
            size: 20,
            color: controller.product.value?.isFavorite ?? false
                ? Colors.red
                : Colors.black,
          )),
        ),
      ),
    );
  }
}

class ImagePageIndicators extends StatelessWidget {
  final ProductDetailControllerImp controller;
  
  const ImagePageIndicators({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final images = controller.getProductImages();
    return Container(
      width: 51,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          images.length,
          (index) => Obx(() => Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == controller.selectedImageIndex.value
                  ? Colors.black
                  : Colors.grey[300],
            ),
          )),
        ),
      ),
    );
  }
}