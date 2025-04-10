import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/app/core/theme/app_color_extension.dart';

class ProductCard extends StatelessWidget {
  final List<ProductModels> products;
  final Function(String) onProductTap;
  final Function(String) onFavoriteTap;
  final String title;
  final VoidCallback? onSeeAllTap;
  final bool isHorizontal;

  const ProductCard({
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
        // Products display - either horizontal list or grid
        if (isHorizontal) 
          _buildHorizontalList(context) 
        else 
          _buildGrid(context),
      ],
    );
  }

  Widget _buildHorizontalList(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorExtension>();
    return SizedBox(
      // Increased height from 281 to 290 to accommodate content
      height: 290,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductCard(context, product, 159, colors);
        },
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorExtension>();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(), // Changed to prevent scroll conflict
        scrollDirection: Axis.vertical,
        shrinkWrap: true, // Changed to true to properly size the grid
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 159 / 290, // Changed from 159/281 to 159/290
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductCard(context, product, 159, colors);
        },
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context, 
    ProductModels product, 
    double width, 
    AppColorExtension? colors,
  ) {
    return GestureDetector(
      onTap: () => onProductTap(product.id ?? ''),
      child: Container(
        width: width,
        margin: isHorizontal ? const EdgeInsets.only(right: 16) : null,
        decoration: BoxDecoration(
          color: colors?.productCard ?? Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colors?.border ?? const Color(0xFFF4F4F4),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with favorite button
            SizedBox(
              height: 220,
              width: width,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: _buildProductImage(product),
                  ),
                  _buildFavoriteButton(product),
                ],
              ),
            ),
            
            // Product details - using Expanded to prevent overflow
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Added to minimize space taken
                children: [
                  // Product name - limited to 1 line to ensure consistent height
                  Text(
                    product.name ?? 'Unknown Product',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Product price
                  _buildPriceSection(product),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(ProductModels product) {
    return Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: () => onFavoriteTap(product.id ?? ''),
        child: SvgPicture.asset(
          AssetConfig.heartIcon,
          colorFilter: ColorFilter.mode(
            product.isFavorite ?? false ? Colors.red : Colors.grey,
            BlendMode.srcIn,
          ),
          height: 24,
          width: 24,
        ),
      ),
    );
  }


  // Price section showing current price and original price if discounted
  Widget _buildPriceSection(ProductModels product) {
    final double originalPrice = double.tryParse(product.price ?? '0.00') ?? 0.00;
    final double discountAmount = double.tryParse(product.discount ?? '0.00') ?? 0.00;
    final double finalPrice = originalPrice - discountAmount > 0 ? originalPrice - discountAmount : originalPrice;
    
    return Row(
      children: [
        // Display the final price
        Text(
          '\$${finalPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        // If there's a discount, show the original price with strikethrough
        if (discountAmount > 0)
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              '\$${originalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProductImage(ProductModels product) {
    final List<String> images = product.imageUrls?.split(',') ?? [];

    if (images.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.image, size: 40, color: Colors.grey),
        ),
      );
    }

    String imageUrl = images[0];
    
    if (imageUrl.isNotEmpty) {
      return Image.asset(
        imageUrl,
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
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
        ),
      );
    }
  }
}