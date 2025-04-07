import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
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
  final ProductController productController = Get.find<ProductController>();

  int quantity = 1;
  String? selectedSize;
  String? selectedColor = "Black"; 
  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    print('Navigated to product ID: ${widget.productId}');
    productController.fetchProductDetails(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Obx(() {
        if (productController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary(context)),
          );
        } else if (productController.hasError.value) {
          return Center(
            child: Text('Error: ${productController.errorMessage.value}'),
          );
        } else if (productController.selectedProduct.value == null) {
          return Center(child: Text('Product not found'));
        } else {
          final product = productController.selectedProduct.value!;
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
                          productController.toggleFavorite(widget.productId);
                        },
                      ),
                    ),

                    // Image page indicators at bottom center
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ImagePageIndicator(
                          currentIndex: currentImageIndex,
                          totalImages:
                              product.images.length > 0
                                  ? product.images.length
                                  : 3,
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
                            'Roller Rabbit',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: AppColors.foreground(context),
                            ),
                          ),
                        ),

                        // Quantity selector
                        QuantitySelector(
                          quantity: quantity,
                          onQuantityChanged: (value) {
                            setState(() {
                              quantity = value;
                            });
                          },
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
                            child: SizeSelector(
                              selectedSize: selectedSize,
                              onSizeSelected: (size) {
                                setState(() {
                                  selectedSize = size;
                                });
                              },
                            ),
                          ),

                          // Color selector
                          Positioned(
                            top: 0,
                            right: 0,
                            child: ColorSelector(
                              selectedColor: selectedColor,
                              onColorSelected: (color) {
                                setState(() {
                                  selectedColor = color;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Product description
                    const SizedBox(height: 20),
                    ProductDescription(
                      description:
                          "Get a little lift from these Sam Edelman sandals featuring ruched straps and leather lace-up ties, while a braided jute sole makes a fresh statement for summer.",
                    ),

                    // Price and add to cart button
                    const SizedBox(height: 24),
                    AddToCartButton(
                      price: product.price,
                      onPressed: () {
                        Map<String, String> variants = {};
                        if (selectedSize != null) {
                          variants['size'] = selectedSize!;
                        }
                        if (selectedColor != null) {
                          variants['color'] = selectedColor!;
                        }

                        Get.snackbar(
                          'Success',
                          'Added to cart',
                          snackPosition: SnackPosition.BOTTOM,
                        );
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
