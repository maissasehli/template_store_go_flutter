import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/features/product/models/product_modal.dart';
import 'package:store_go/app/shared/widgets/rating_stars.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({Key? key, required this.productId})
    : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductController productController = Get.find<ProductController>();

  int quantity = 1;
  String? selectedSize;
  String? selectedColor = "Black"; // Default to black color

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
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.6,
                color: AppColors.muted(context),
                child: _buildProductImage(product),
              ),

              // Top navigation and controls
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row with back button and share button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back button
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.card(context),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.chevron_left,
                                size: 24,
                                color: AppColors.foreground(context),
                              ),
                              padding: EdgeInsets.zero,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),

                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.card(context),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              // Center the icon in the container
                              child: SvgPicture.asset(
                                AssetConfig.panierIcon,
                                width: 16,
                                height: 16,
                                colorFilter: ColorFilter.mode(
                                  AppColors.foreground(context),
                                  BlendMode.srcIn,
                                ),
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
                          color: AppColors.card(context),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.border(context),
                            width: 1,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            productController.toggleFavorite(widget.productId);
                          },
                          child: Center(
                            child: Icon(
                              product.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 20,
                              color:
                                  product.isFavorite
                                      ? AppColors.destructive(context)
                                      : AppColors.foreground(context),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Image page indicators at bottom center
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (index) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    index == 0
                                        ? AppColors.foreground(context)
                                        : AppColors.border(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.42,
                minChildSize: 0.42,
                maxChildSize: 0.8,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.card(context),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product title and quantity selector
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Title
                              Text(
                                'Roller Rabbit',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  color: AppColors.foreground(context),
                                ),
                              ),

                              // Quantity selector
                              Container(
                                height: 30,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.muted(context),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Minus button
                                    InkWell(
                                      onTap: () {
                                        if (quantity > 1) {
                                          setState(() {
                                            quantity--;
                                          });
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Text(
                                          '-',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.foreground(
                                              context,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Quantity display
                                    Text(
                                      '$quantity',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.foreground(context),
                                      ),
                                    ),
                                    // Plus button
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          quantity++;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Text(
                                          '+',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.foreground(
                                              context,
                                            ),
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
                            'Vado Odelle Dress',
                            style: TextStyle(
                              color: AppColors.mutedForeground(context),
                              fontSize: 11,
                              fontFamily: 'Poppins',
                            ),
                          ),

                          // Rating and available stock
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Rating stars and reviews
                              Row(
                                children: [
                                  RatingStars(rating: product.rating),
                                  const SizedBox(width: 8),
                                  Text(
                                    '(${product.stockQuantity} Reviews)',
                                    style: TextStyle(
                                      color: AppColors.mutedForeground(context),
                                      fontSize: 11,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),

                              // Available in stock text
                              Text(
                                'Available in stock',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  color: AppColors.foreground(context),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          SizedBox(
                            height: 70,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
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
                                  child: Row(
                                    children: [
                                      _buildSizeOption('S'),
                                      _buildSizeOption('M'),
                                      _buildSizeOption('L'),
                                      _buildSizeOption('XL'),
                                      _buildSizeOption('XXL'),
                                    ],
                                  ),
                                ),

                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.card(context),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.border(
                                            context,
                                          ).withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedColor = 'White';
                                            });
                                          },
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            margin: const EdgeInsets.only(
                                              bottom: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              border: Border.all(
                                                color: AppColors.border(
                                                  context,
                                                ),
                                              ),
                                            ),
                                            child:
                                                selectedColor == 'White'
                                                    ? Center(
                                                      child: Icon(
                                                        Icons.check,
                                                        size: 16,
                                                        color:
                                                            AppColors.foreground(
                                                              context,
                                                            ),
                                                      ),
                                                    )
                                                    : null,
                                          ),
                                        ),

                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedColor = 'Black';
                                            });
                                          },
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            margin: const EdgeInsets.only(
                                              bottom: 6,
                                            ),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),

                                        // Green color
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedColor = 'Green';
                                            });
                                          },
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            margin: const EdgeInsets.only(
                                              bottom: 6,
                                            ),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),

                                        // Orange color
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedColor = 'Orange';
                                            });
                                          },
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Description section
                          const SizedBox(height: 20),
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: AppColors.foreground(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Get a little lift from these Sam Edelman sandals featuring ruched straps and leather lace-up ties, while a braided jute sole makes a fresh statement for summer.",
                            style: TextStyle(
                              color: AppColors.mutedForeground(context),
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
                              // Price
                              Text(
                                '\$198.00',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.foreground(context),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Add to cart button
                              Expanded(
                                child: ElevatedButton(
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
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary(context),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        AssetConfig.bagIcon,
                                        color: AppColors.primaryForeground(
                                          context,
                                        ),
                                        width: 16,
                                        height: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Add to Panier',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryForeground(
                                            context,
                                          ),
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
                                color: AppColors.border(context),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildSizeOption(String size) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = size;
        });
      },
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              selectedSize == size
                  ? AppColors.primary(context)
                  : AppColors.card(context),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              color:
                  selectedSize == size
                      ? AppColors.primaryForeground(context)
                      : AppColors.foreground(context),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    if (product.images.isEmpty) {
      return Container(
        color: AppColors.muted(context),
        child: Center(
          child: Icon(
            Icons.image_not_supported,
            size: 50,
            color: AppColors.mutedForeground(context),
          ),
        ),
      );
    }

    return PageView.builder(
      itemCount: product.images.length,
      itemBuilder: (context, index) {
        final image = product.images[index];

        if (image.startsWith('asset://')) {
          return Image.asset(
            image.replaceFirst('asset://', ''),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.muted(context),
                child: Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 40,
                    color: AppColors.mutedForeground(context),
                  ),
                ),
              );
            },
          );
        } else {
          return Image.network(
            image,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.muted(context),
                child: Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 40,
                    color: AppColors.mutedForeground(context),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
