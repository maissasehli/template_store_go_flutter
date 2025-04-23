import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/home/views/widgets/product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Function(String) onProductTap;
  final Function(String) onFavoriteTap;
  final bool isHorizontal;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onFavoriteTap,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return _buildHorizontalList(context);
    } else {
      return _buildGrid(context);
    }
  }

  Widget _buildHorizontalList(BuildContext context) {
    return SizedBox(
      height: 281,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ProductCard(
              product: product,
              onProductTap: onProductTap,
              onFavoriteTap: onFavoriteTap,
              width: 159,
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
          childAspectRatio: 0.7,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: products.length > 4 ? 4 : products.length,
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