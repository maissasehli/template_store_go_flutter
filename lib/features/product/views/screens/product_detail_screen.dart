import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/product/controllers/product_detail_controller.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/product/views/widgets/product_image_gallery.dart';
import 'package:store_go/features/product/views/widgets/top_navigation_bar.dart';
import 'package:store_go/features/product/views/widgets/size_selector.dart';
import 'package:store_go/features/product/views/widgets/color_selector.dart';
import 'package:store_go/features/product/views/widgets/quantity_selector.dart';
import 'package:store_go/features/product/views/widgets/product_info.dart';
import 'package:store_go/features/product/views/widgets/add_to_cart_button.dart';
import 'package:store_go/features/product/views/widgets/product_description.dart';
import 'package:store_go/features/product/views/widgets/favorite_button.dart';
import 'package:store_go/features/product/views/widgets/image_page_indicator.dart';
import 'package:store_go/features/product/views/widgets/draggable_info_sheet.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen> {
  // Use the new dedicated controller
  final ProductDetailController detailController =
      Get.find<ProductDetailController>();

  @override
  void initState() {
    super.initState();
    // Fetch product details using the dedicated controller
    detailController.fetchProductDetails(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Obx(() {
        // Access state properties through the controller's state object
        if (detailController.state.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary(context)),
          );
        } else if (detailController.state.hasError.value) {
          return Center(
            child: Text('Error: ${detailController.state.errorMessage.value}'),
          );
        } else if (detailController.state.product.value == null) {
          return Center(child: Text('Product not found'));
        } else {
          final product = detailController.state.product.value!;
          return Stack(
            children: [
              // Main product image area
              ProductImageGallery(product: product),

              // Top navigation and controls
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top navigation bar
                    TopNavigationBar(
                      onBackPressed: () => Navigator.pop(context),
                      onCartPressed: () {
                        // Navigate to cart
                      },
                    ),

                    // Spacer to push content to bottom
                    const Spacer(),

                    // Favorite button positioned at bottom left of image
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                      child: FavoriteButton(
                        isFavorite: product.isFavorite,
                        onToggleFavorite: () {
                          // Use the controller's method directly
                          detailController.toggleFavorite();
                        },
                      ),
                    ),

                    // Image page indicators at bottom center
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Obx(
                          () => ImagePageIndicator(
                            currentIndex:
                                detailController.state.currentImageIndex.value,
                            totalImages:
                                product.images.length > 0
                                    ? product.images.length
                                    : 3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // Draggable info sheet
              DraggableInfoSheet(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product title row with quantity selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title - will be replaced with actual product name
                        Expanded(
                          child: Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: AppColors.foreground(context),
                            ),
                          ),
                        ),
                        // Quantity selector
                        Obx(
                          () => QuantitySelector(
                            quantity: detailController.state.quantity.value,
                            onQuantityChanged: (value) {
                              detailController.updateQuantity(value);
                            },
                          ),
                        ),
                      ],
                    ),

                    // Product info
                    ProductInfo(product: product),
                    const SizedBox(height: 16),

                    SizedBox(
                      height: 70,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Size selector
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Text(
                              'Size',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                color: AppColors.foreground(context),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 40,
                            left: 0,
                            child: Obx(
                              () => SizeSelector(
                                selectedSize:
                                    detailController.state.selectedSize.value,
                                onSizeSelected: (size) {
                                  detailController.updateSize(size);
                                },
                              ),
                            ),
                          ),

                          // Color selector
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Obx(
                              () => ColorSelector(
                                selectedColor:
                                    detailController.state.selectedColor.value,
                                onColorSelected: (color) {
                                  detailController.updateColor(color);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Product description
                    const SizedBox(height: 20),
                    ProductDescription(description: product.description),

                    // Price and add to cart button
                    const SizedBox(height: 24),
                    AddToCartButton(
                      price: product.price,
                      onPressed: () {
                        detailController.addToCart();
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
