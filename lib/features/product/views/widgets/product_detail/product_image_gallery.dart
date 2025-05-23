import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
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
      color: AppColors.secondary(context),
      child: _buildProductImageGallery(context),
    );
  }

  Widget _buildProductImageGallery(BuildContext context) {
    if (widget.product.images.isEmpty) {
      return Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.muted(context),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.image_outlined,
            size: 64,
            color: AppColors.mutedForeground(context),
          ),
        ),
      );
    }

    return PageView.builder(
      controller: _pageController,
      onPageChanged: widget.onPageChanged,
      itemCount: widget.product.images.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              widget.product.images[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.muted(context),
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 64,
                    color: AppColors.mutedForeground(context),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.muted(context),
                  child: Center(
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                      color: AppColors.primary(context),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
