import 'package:flutter/material.dart';
import 'package:store_go/app/shared/widgets/universal_cached_image.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

class ProductImage extends StatelessWidget {
  final Product product;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool maintainAspectRatio;

  const ProductImage({
    super.key,
    required this.product,
    this.width,
    this.height,
    this.fit = BoxFit.cover, // Changed back to cover as default
    this.maintainAspectRatio = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Added ClipRRect to ensure content stays within borders
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      child: Container(
        width: width,
        height: height,
        color: AppColors.muted(context),
        child: _buildImage(context),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (product.images.isEmpty) {
      return _buildPlaceholder(context);
    }

    final String imagePath = product.images[0];

    // Determine if it's an asset or network image
    final bool isAsset = imagePath.startsWith('asset://');
    final ImageSource source =
        isAsset ? ImageSource.asset : ImageSource.network;
    final String path =
        isAsset ? imagePath.replaceFirst('asset://', '') : imagePath;

    return UniversalCachedImage(
      imagePath: path,
      source: source,
      width: double.infinity, // Fill entire width
      height: double.infinity, // Fill entire height
      fit: BoxFit.cover, // Always use cover to prevent gaps
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      errorWidget: _buildPlaceholder(context),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.muted(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          color: AppColors.mutedForeground(context),
        ),
      ),
    );
  }
}
