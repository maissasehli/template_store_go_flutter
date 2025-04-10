import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_color_extension.dart';
import 'package:store_go/features/product/controllers/product_detail_controller.dart';
import 'package:store_go/app/shared/widgets/rating_stars.dart';

class ProductDetail extends GetView<ProductDetailControllerImp> {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorExtension>();
    
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
        return _buildProductUI(context);
      }),
    );
  }

  // Separate method to build the product UI to avoid nesting Obx
  Widget _buildProductUI(BuildContext context) {
    return Stack(
      children: [
        // Main product image area
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.6,
          color: Colors.grey[200],
          child: _buildImageGallery(context),
        ),

        // Top navigation and controls
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with back button and cart button
              Padding(
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
              ),

              // Spacer to push content to bottom
              const Spacer(),

              // Favorite button positioned at bottom left of image
              Padding(
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
              ),

              // Image page indicators
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildImageIndicators(),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Draggable product info panel
        DraggableScrollableSheet(
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
                child: _buildProductDetails(context),
              ),
            );
          },
        ),
      ],
    );
  }

  // Separate widget for image indicators to avoid nesting Obx
Widget _buildImageIndicators() {
  return Builder(
    builder: (context) {
      final images = controller.getProductImages();
      return Container(
        width: 51, // Close to 50.96px shown in design
        height: 16, // Close to 15.6px shown in design
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
    },
  );
}

  Widget _buildImageGallery(BuildContext context) {
    final images = controller.getProductImages();
    
    if (images.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
        ),
      );
    }

    return PageView.builder(
      itemCount: images.length,
      onPageChanged: (index) {
        controller.selectImage(index);
      },
      itemBuilder: (context, index) {
        final imageUrl = images[index].trim();
        
        if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
          return Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / 
                        loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          );
        } else {
          return Image.asset(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product title and quantity selector
        Row(
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
            Container(
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
            ),
          ],
        ),

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
        Row(
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
        ),

        // Size selector
        const SizedBox(height: 16),
        SizedBox(
          height: 70,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Positioned(
                top: 0,
                left: 0,
                child: Text(
                  'Size',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              Positioned(
                top: 40,
                left: 0,
                child: Row(
                  children: [
                    _buildSizeOption(context, 'S'),
                    _buildSizeOption(context, 'M'),
                    _buildSizeOption(context, 'L'),
                    _buildSizeOption(context, 'XL'),
                    _buildSizeOption(context, 'XXL'),
                  ],
                ),
              ),

              // Color selector
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildColorOption(Colors.white, 'White'),
                      _buildColorOption(Colors.black, 'Black'),
                      _buildColorOption(Colors.green, 'Green'),
                      _buildColorOption(Colors.orange, 'Orange'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Description section
        const SizedBox(height: 20),
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

        // Price and add to cart button
        const SizedBox(height: 24),
        Row(
          children: [
            // Price with Obx at correct level
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
        ),

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
    );
  }

  Widget _buildSizeOption(BuildContext context, String size) {
    return Obx(() {
      final selectedSize = controller.selectedSize.value;
      
      return GestureDetector(
        onTap: () {
          controller.selectSize(size);
        },
        child: Container(
          width: 36,
          height: 36,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selectedSize == size ? Colors.black : Colors.white,
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: Text(
              size,
              style: TextStyle(
                color: selectedSize == size ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildColorOption(Color color, String colorName) {
    return Obx(() {
      final selectedColor = controller.selectedColor.value;
      final isSelected = selectedColor == colorName;
      
      return GestureDetector(
        onTap: () {
          controller.selectColor(colorName);
        },
        child: Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: color == Colors.white
                ? Border.all(color: Colors.grey[300]!)
                : null,
          ),
          child: isSelected
              ? Center(
                  child: Icon(
                    Icons.check,
                    size: 16,
                    color: color == Colors.white ? Colors.black : Colors.white,
                  ),
                )
              : null,
        ),
      );
    });
  }
}