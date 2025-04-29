import 'package:flutter/material.dart';
import 'package:store_go/features/product/models/product_model.dart';

class ProductImageGallery extends StatefulWidget {
  final Product product;
  final double height;
  final Function(int)? onPageChanged;

  const ProductImageGallery({
    super.key,
    required this.product,
    this.height = 0.6,
    this.onPageChanged,
  });

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * widget.height,
      color: Colors.grey[300],
      child: _buildProductImageGallery(context),
    );
  }

  Widget _buildProductImageGallery(BuildContext context) {
    if (widget.product.images.isEmpty) {
      return const Center(child: Icon(Icons.image_not_supported, size: 50));
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: widget.product.images.length,
      onPageChanged: widget.onPageChanged,
      itemBuilder: (context, index) {
        return Image.network(
          widget.product.images[index],
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.broken_image, size: 40));
          },
        );
      },
    );
  }
}