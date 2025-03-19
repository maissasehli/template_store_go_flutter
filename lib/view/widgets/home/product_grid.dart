import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/core/constants/assets_constants.dart';
import 'package:store_go/core/constants/ui.dart';
import 'package:store_go/core/model/home/product_model.dart';
import 'package:store_go/core/theme/color_extension.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Function(String) onProductTap;
  final Function(String) onFavoriteTap;
  final String title;
  final VoidCallback? onSeeAllTap;
  final bool isHorizontal;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onFavoriteTap,
    this.title = 'Top Selling',
    this.onSeeAllTap,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title is handled in the parent HomeScreen
        
        // Products display - either horizontal list or grid
        if (isHorizontal)
          _buildHorizontalList(context)
        else
          _buildGrid(),
      ],
    );
  }

  Widget _buildHorizontalList(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorExtension>();
    return SizedBox(
      height: 281, // Exact height from image 2 (Hug 281px)
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: UIConstants.paddingMedium),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          
          return GestureDetector(
            onTap: () => onProductTap(product.id),
            child: Container(
              width: 159, // Exact width from image 2 (Fixed 159px)
              margin: const EdgeInsets.only(right: 8), // Gap 8px from image 2
              decoration: BoxDecoration(
                color: colors?.productCard ?? Colors.white,
                borderRadius: BorderRadius.circular(8), // Radius 8px from image 2
                border: Border.all(color: colors?.border ?? Color(0xFFF4F4F4), width: 1), // Border color from image 2
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image with favorite button
                  SizedBox(
                    height: 220, // Height for the image container
                    child: Stack(
                      children: [
                        // Product image
                        _buildProductImage(product),
                        
                        // Favorite button using SVG
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => onFavoriteTap(product.id),
                            child: SvgPicture.asset(
                              ImageAsset.heartIcon,
                              colorFilter: ColorFilter.mode(
                                product.isFavorite ? Colors.red : Colors.grey,
                                BlendMode.srcIn,
                              ),
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Product details
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product name - limit to 1 line with ellipsis
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        
                        // Product price - show current price and strikethrough if applicable
                        Row(
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            
                            // Example of how to show a strikethrough price for specific products
                            if (product.id == '2') // For Max Cirro Slides
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                  '\$100.00',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.grey[500],
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.only(
        left: UIConstants.paddingMedium,
        right: UIConstants.paddingMedium,
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7, // Adjusted to match the height/width ratio in images
          crossAxisSpacing: 8, // Gap 8px from image 2
          mainAxisSpacing: 8, // Gap 8px from image 2
        ),
        itemCount: products.length > 4 ? 4 : products.length, // Limit to 4 items
        itemBuilder: (context, index) {
          final product = products[index];
          
          return GestureDetector(
            onTap: () => onProductTap(product.id),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8), // Radius 8px from image 2
                border: Border.all(color: Color(0xFFF4F4F4), width: 1), // Border color from image 2
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image with favorite button
                  Expanded(
                    child: Stack(
                      children: [
                        // Product image
                        _buildProductImage(product),
                        
                        // Favorite button using SVG
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => onFavoriteTap(product.id),
                            child: SvgPicture.asset(
                              ImageAsset.heartIcon,
                              colorFilter: ColorFilter.mode(
                                product.isFavorite ? Colors.red : Colors.black,
                                BlendMode.srcIn,
                              ),
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Product details
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product name - limit to 1 line with ellipsis
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        
                        // Product price - show current price and strikethrough if applicable
                        Row(
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            
                            if (product.id == '2') 
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                  '\$100.00',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.grey[500],
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    if (product.images.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.image, size: 40, color: Colors.grey),
        ),
      );
    }

    String imageUrl = product.images[0];
    
    // Handle asset images
    if (imageUrl.startsWith('asset://')) {
      final assetPath = imageUrl.replaceFirst('asset://', '');
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8), // Match overall radius
          topRight: Radius.circular(8), // Match overall radius
        ),
        child: Image.asset(
          assetPath,
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
        ),
      );
    } else {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
        ),
      );
    }
  }
}