import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/product/controllers/product_detail_controller.dart';
import 'package:store_go/features/product/views/widgets/product_detail/favorite_button.dart';
import 'package:store_go/features/product/views/widgets/product_detail/product_description.dart';
import 'package:store_go/features/product/views/widgets/product_detail/product_image_gallery.dart';
import 'package:store_go/features/product/views/widgets/product_detail/product_info.dart';
import 'package:store_go/features/product/views/widgets/product_detail/top_navigation_bar.dart';
import 'package:store_go/features/product/views/widgets/product_detail/size_selector.dart';
import 'package:store_go/features/product/views/widgets/product_detail/color_selector.dart';
import 'package:store_go/features/product/views/widgets/product_detail/quantity_selector.dart';
import 'package:store_go/features/product/views/widgets/product_detail/add_to_cart_button.dart';
import 'package:store_go/features/product/views/widgets/product_detail/image_page_indicator.dart';
import 'package:store_go/features/product/views/widgets/product_detail/draggable_info_sheet.dart';
import 'package:store_go/features/promotion/controller/promotion_controller.dart';
import 'package:store_go/features/promotion/views/product_promotion.dart';
import 'package:store_go/features/review/view/widgets/review_section/review_section.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  final ProductDetailController detailController =
      Get.find<ProductDetailController>();
  final promotionController = Get.put(
    PromotionController(promotionRepository: Get.find()),
  );
  String? selectedColor;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _initializeProduct();
  }

  void _initializeAnimation() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _initializeProduct() {
    detailController.fetchProductDetails(widget.productId);
    detailController.state.product.listen((product) {
      if (product != null &&
          product.variants['color'] != null &&
          product.variants['color']!.isNotEmpty) {
        setState(() {
          selectedColor = product.variants['color']![0];
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildSkeletonLoading(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.cardColor;
    final hintColor = theme.colorScheme.onSurface.withOpacity(0.08);

    return Stack(
      children: [
        // Skeleton for Product Image Gallery
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.5,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color.lerp(
                    hintColor,
                    surfaceColor,
                    _pulseAnimation.value,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 60,
                    color: theme.colorScheme.onSurface.withOpacity(0.2),
                  ),
                ),
              );
            },
          ),
        ),

        // Skeleton for Top Navigation Bar
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavButton(Icons.arrow_back),
                _buildNavButton(Icons.shopping_cart_outlined),
              ],
            ),
          ),
        ),

        // Skeleton for Favorite Button
        SafeArea(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 420.0),
              child: _buildSkeletonCircle(35),
            ),
          ),
        ),

        // Skeleton for Image Page Indicator
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 420.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.lerp(
                            hintColor,
                            surfaceColor,
                            _pulseAnimation.value,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ),
        ),

        // Skeleton for Draggable Info Sheet
        DraggableInfoSheet(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skeleton for Product Name and Quantity Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSkeletonBox(150, 20),
                    _buildSkeletonBox(80, 30, borderRadius: 15),
                  ],
                ),
                const SizedBox(height: 8),

                // Skeleton for Product Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [_buildSkeletonBox(100, 18)]),
                    _buildSkeletonBox(80, 14),
                  ],
                ),
                const SizedBox(height: 16),

                // Skeleton for Size Selector
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSkeletonBox(50, 18),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: _buildSkeletonCircle(35),
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Skeleton for Color Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSkeletonBox(100, 18),
                        const SizedBox(height: 8),
                        _buildSkeletonBox(
                          MediaQuery.of(context).size.width * 0.6,
                          40,
                        ),
                      ],
                    ),
                    Column(
                      children: List.generate(2, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _buildSkeletonCircle(35),
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Skeleton for Product Description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSkeletonBox(100, 18),
                    const SizedBox(height: 8),
                    _buildSkeletonBox(double.infinity, 40),
                  ],
                ),
                const SizedBox(height: 8),

                // Skeleton for Review Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSkeletonBox(150, 20),
                        _buildSkeletonBox(80, 20),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSkeletonBox(double.infinity, 100),
                    const SizedBox(height: 16),
                    _buildSkeletonBox(double.infinity, 40),
                  ],
                ),
                const SizedBox(height: 16),

                // Skeleton for Add to Cart Button
                Row(
                  children: [
                    _buildSkeletonBox(60, 20),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSkeletonBox(
                        double.infinity,
                        50,
                        borderRadius: 25,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonBox(
    double width,
    double height, {
    double borderRadius = 10,
  }) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Color.lerp(
              AppColors.muted(context).withOpacity(0.08),
              AppColors.card(context),
              _pulseAnimation.value,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonCircle(double size) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.lerp(
              AppColors.muted(context).withOpacity(0.08),
              AppColors.card(context),
              _pulseAnimation.value,
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.card(context),
        boxShadow: [
          BoxShadow(
            color: AppColors.muted(context).withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.mutedForeground(context), size: 20),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    final bool isRtl = LocalizationService.isRtl(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: AppColors.destructive(context),
          ),
          const SizedBox(height: 16),
          Text(
            'product_detail.error_loading'.translate() + errorMessage,
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.destructive(context),
              ),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed:
                () => detailController.fetchProductDetails(widget.productId),
            icon: const Icon(Icons.refresh_rounded),
            label: Text(
              'product_detail.try_again'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                const TextStyle(),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: AppColors.primaryForeground(context),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductNotFound() {
    final bool isRtl = LocalizationService.isRtl(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: AppColors.mutedForeground(context),
          ),
          const SizedBox(height: 16),
          Text(
            'product_detail.product_not_found'.translate(),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.foreground(context),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'product_detail.product_not_exist'.translate(),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                fontSize: 14,
                color: AppColors.mutedForeground(context),
              ),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              isRtl ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
            ),
            label: Text(
              'product_detail.back'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                const TextStyle(),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: AppColors.primaryForeground(context),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Obx(() {
        if (detailController.state.isLoading.value) {
          return _buildSkeletonLoading(context);
        } else if (detailController.state.hasError.value) {
          return _buildErrorState(detailController.state.errorMessage.value);
        } else if (detailController.state.product.value == null) {
          return _buildProductNotFound();
        } else {
          final product = detailController.state.product.value!;
          return Stack(
            children: [
              ProductImageGallery(
                product: product,
                onPageChanged: (index) {
                  detailController.updateImageIndex(index);
                },
              ),
              if (product.images.length > 1)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, bottom: 420.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: ImagePageIndicator(
                        currentIndex:
                            detailController.state.currentImageIndex.value,
                        totalImages: product.images.length,
                      ),
                    ),
                  ),
                ),
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
                  alignment:
                      isRtl ? Alignment.bottomLeft : Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: isRtl ? 0 : 16.0,
                      left: isRtl ? 16.0 : 0,
                      bottom: 420.0,
                    ),
                    child: FavoriteButton(productId: product.id),
                  ),
                ),
              ),

              DraggableInfoSheet(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        isRtl
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    children: [
                      Row(
                        textDirection:
                            isRtl ? TextDirection.rtl : TextDirection.ltr,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: LocalizationService.getLocalizedTextStyle(
                                context,
                                TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  color: AppColors.foreground(context),
                                ),
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

                      ProductInfo(product: product),
                      const SizedBox(height: 8),

                      ProductPromotionView(
                        productId: product.id,
                        controller: promotionController,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        textDirection:
                            isRtl ? TextDirection.rtl : TextDirection.ltr,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizeSelector(
                              selectedSize:
                                  detailController.state.selectedSize.value,
                              sizes: product.variants['size'] ?? [],
                              onSizeSelected: (size) {
                                detailController.updateSize(size);
                              },
                            ),
                          ),
                          ColorSelector(
                            selectedColor:
                                selectedColor ??
                                (product.variants['color']?.isNotEmpty ?? false
                                    ? product.variants['color']![0]
                                    : ''),
                            colors: product.colors,
                            onColorSelected: (color) {
                              setState(() {
                                selectedColor = color;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ProductDescription(description: product.description),
                      const SizedBox(height: 8),

                      ReviewSection(
                        initialReviews: product.reviews,
                        product: product,
                      ),
                      const SizedBox(height: 16),
                      AddToCartButton(
                        price: product.price,
                        product: product,
                        quantity: detailController.state.quantity.value,
                        variantId: detailController.state.selectedSize.value,
                        onAddPressed: () {
                          detailController.addToCart();
                        },
                        onRemovePressed: () {
                          // Just handle the removal without showing a toast
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
