// product_detail.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/product/controllers/product_detail_controller.dart';
import 'package:store_go/features/product/views/widgets/product_details/product_image_gallery.dart';
import 'package:store_go/features/product/views/widgets/product_details/product_info_panel.dart';
import 'package:store_go/features/product/views/widgets/product_details/top_navigation_bar.dart';
// New import

class ProductDetail extends GetView<ProductDetailControllerImp> {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        // Main loading state handler
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.product.value == null) {
          return const Center(child: Text('Product not found'));
        }
        
        // Only render the UI when we have product data
        return Stack(
          children: [
            // Main product image area
            ProductImageGallery(
              controller: controller,
              height: MediaQuery.of(context).size.height * 0.6,
            ),

            // Top navigation bar with back and cart buttons
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top navigation bar
                  const TopNavigationBar(),

                  // Spacer to push content to bottom
                  const Spacer(),

                  // Favorite button positioned at bottom left of image
                  FavoriteButton(controller: controller),

                  // Image page indicators
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ImagePageIndicators(controller: controller),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Draggable product info panel
            ProductInfoPanel(controller: controller),
          ],
        );
      }),
    );
  }
}