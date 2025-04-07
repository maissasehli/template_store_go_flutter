import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/product/models/product_modal.dart';

class ProductImageGallery extends StatelessWidget {
  final Product product;
  final double height;

  const ProductImageGallery({
    super.key,
    required this.product,
    this.height = 0.6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * height,
      color: AppColors.muted(context),
      child: _buildProductImage(context),
    );
  }

  Widget _buildProductImage(BuildContext context) {
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
