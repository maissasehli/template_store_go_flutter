import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/home/views/widgets/product_card.dart';

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
          _buildGrid(context),
      ],
    );
  }

  Widget _buildHorizontalList(BuildContext context) {
    return SizedBox(
      height: 281, // Exact height from image 2 (Hug 281px)
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Padding(
            padding: const EdgeInsets.only(right: 8), // Gap 8px
            child: ProductCard(
              product: product,
              onProductTap: onProductTap,
              onFavoriteTap: onFavoriteTap,
              width: 159, // Exact width from image 2 (Fixed 159px)
              height: 280,
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: UIConfig.paddingMedium,
        right: UIConfig.paddingMedium,
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7, // Adjusted to match the height/width ratio
          crossAxisSpacing: 8, // Gap 8px
          mainAxisSpacing: 8, // Gap 8px
        ),
        itemCount:
            products.length > 4 ? 4 : products.length, // Limit to 4 items
        itemBuilder: (context, index) {
          final product = products[index];

          return ProductCard(
            product: product,
            onProductTap: onProductTap,
            onFavoriteTap: onFavoriteTap,
          );
        },
      ),
    );
  }
}
