import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/product/controllers/product_detail_controller.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/product/views/widgets/favorite_button.dart';
import 'package:store_go/features/product/views/widgets/product_image_gallery.dart';
import 'package:store_go/features/product/views/widgets/top_navigation_bar.dart';
import 'package:store_go/features/product/views/widgets/size_selector.dart';
import 'package:store_go/features/product/views/widgets/color_selector.dart';
import 'package:store_go/features/product/views/widgets/quantity_selector.dart';
import 'package:store_go/features/product/views/widgets/product_info.dart';
import 'package:store_go/features/product/views/widgets/add_to_cart_button.dart';
import 'package:store_go/features/product/views/widgets/product_description.dart';
import 'package:store_go/features/product/views/widgets/image_page_indicator.dart';
import 'package:store_go/features/product/views/widgets/draggable_info_sheet.dart';
import 'package:store_go/features/product/views/widgets/review_section.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductDetailController detailController =
      Get.find<ProductDetailController>();
  String? selectedColor; // State variable for selected color

  @override
  void initState() {
    super.initState();
    detailController.fetchProductDetails(widget.productId);
    // Initialize selectedColor after fetching product details
    detailController.state.product.listen((product) {
      if (product != null && product.variants['color'] != null && product.variants['color']!.isNotEmpty) {
        setState(() {
          selectedColor = product.variants['color']![0]; // Default to the first color
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Obx(() {
        if (detailController.state.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary(context)),
          );
        } else if (detailController.state.hasError.value) {
          return Center(
            child: Text('Error: ${detailController.state.errorMessage.value}'),
          );
        } else if (detailController.state.product.value == null) {
          return const Center(child: Text('Product not found'));
        } else {
          final product = detailController.state.product.value!;
          return Stack(
            children: [
              ProductImageGallery(product: product),
              SafeArea(
                child: TopNavigationBar(
                  onBackPressed: () => Navigator.pop(context),
                  onCartPressed: () {
                    Get.toNamed('/cart');
                  },
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, bottom: 380.0),
                    child: FavoriteButton(productId: product.id),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 70.0),
                  child: ImagePageIndicator(
                    currentIndex: detailController.state.currentImageIndex.value,
                    totalImages: product.images.isNotEmpty ? product.images.length : 3,
                  ),
                ),
              ),
              DraggableInfoSheet(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                          ),
                        ),
                        QuantitySelector(
                          quantity: detailController.state.quantity.value,
                          onQuantityChanged: (value) {
                            detailController.updateQuantity(value);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ProductInfo(
                      product: product,
                      subtitle: 'Relaxed Cargo Joggers', // Updated subtitle
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Size',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizeSelector(
                          selectedSize: detailController.state.selectedSize.value,
                          sizes: product.variants['size'] ?? [],
                          onSizeSelected: (size) {
                            detailController.updateSize(size);
                          },
                        ),
                        ColorSelector(
                          selectedColor: selectedColor ?? (product.variants['color']?.isNotEmpty ?? false ? product.variants['color']![0] : ''),
                          colors: product.colors, // Now this works with the updated Product class
                          onColorSelected: (color) {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ProductDescription(description: product.description),
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