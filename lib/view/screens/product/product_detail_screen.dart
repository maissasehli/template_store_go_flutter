import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/controller/cart/cart_controller.dart';
import 'package:store_go/controller/product/product_controller.dart';
import 'package:store_go/core/constants/assets_constants.dart';
import 'package:store_go/core/model/home/product_model.dart';
import 'package:store_go/view/widgets/shared/rating_stars.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();

  int quantity = 1;
  String? selectedSize;
  String? selectedColor;

  @override
  void initState() {
    super.initState();
    productController.fetchProductDetails(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        final product = productController.selectedProduct.value;

        if (product == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // Set initial selected size and color if not already set
        if (selectedSize == null && product.variants.containsKey('size')) {
          selectedSize = product.variants['size']!.first;
        }
        if (selectedColor == null && product.variants.containsKey('color')) {
          selectedColor = product.variants['color']!.first;
        }

        return Column(
          children: [
            // Top navigation area
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(ImageAsset.icon),
                      onPressed: () {
                        // Navigate to cart
                        Get.toNamed('/cart');
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Main content area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image
                    SizedBox(
                      height: 400,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          // Product image
                          PageView.builder(
                            itemCount: product.images.length,
                            itemBuilder: (context, index) {
                              final image = product.images[index];
                              
                              if (image.startsWith('asset://')) {
                                return Image.asset(
                                  image.replaceFirst('asset://', ''),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
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
                          ),
                          
                          // Dots indicator
                          Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                product.images.length,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Favorite button
                          Positioned(
                            right: 16,
                            bottom: 100,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  productController.toggleFavorite(widget.productId);
                                },
                                child: Icon(
                                  product.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: product.isFavorite
                                      ? Colors.red
                                      : Colors.black,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Product details card
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Brand and product name
                          const Text(
                            'Roller Rabbit',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.name,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          
                          // Ratings
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              RatingStars(rating: product.rating),
                              const SizedBox(width: 8),
                              Text(
                                '(${product.reviewCount} Reviews)',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          
                          // Available text
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Available in stock',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                              
                              // Quantity selector
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (quantity > 1) {
                                          setState(() {
                                            quantity--;
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        child: const Text(
                                          '-',
                                          style: TextStyle(
                                            fontFamily: 'Gabarito',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '$quantity',
                                      style: const TextStyle(
                                        fontFamily: 'Gabarito',
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          quantity++;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        child: const Text(
                                          '+',
                                          style: TextStyle(
                                            fontFamily: 'Gabarito',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          // Size selector
                          const SizedBox(height: 24),
                          const Text(
                            'Size',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildSizeSelector(product),
                          
                          // Description
                          const SizedBox(height: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Description',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.description,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                              ),
                              
                              // Price and Add to Cart
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Price',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '\$${(product.price * quantity).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontFamily: 'Gabarito',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 24),
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
                                        
                                        cartController.addToCart(
                                          product,
                                          variants,
                                          quantity,
                                        );
                                        Get.snackbar(
                                          'Success',
                                          'Added to cart',
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      },
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
                                            ImageAsset.icon,
                                            colorFilter: const ColorFilter.mode(
                                              Colors.white,
                                              BlendMode.srcIn,
                                            ),
                                            height: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Add to Cart',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          
                          // Bottom spacing
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
  
  Widget _buildSizeSelector(Product product) {
    // Get sizes from product variants or use default sizes
    List<String> sizes = product.variants.containsKey('size') 
        ? product.variants['size']! 
        : ['S', 'M', 'L', 'XL', 'XXL'];
    
    return Row(
      children: sizes.map((size) => 
        GestureDetector(
          onTap: () {
            setState(() {
              selectedSize = size;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selectedSize == size ? Colors.black : Colors.white,
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Center(
              child: Text(
                size,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: selectedSize == size ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
      ).toList(),
    );
  }
}