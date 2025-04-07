import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/widgets/universal_cached_image.dart';
import 'package:store_go/features/product/models/product_modal.dart';

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
      color: AppColors.muted(context),
      child: _buildProductImageGallery(context),
    );
  }

  Widget _buildProductImageGallery(BuildContext context) {
    if (widget.product.images.isEmpty) {
      return _buildEmptyGallery(context);
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: widget.product.images.length,
      onPageChanged: widget.onPageChanged,
      itemBuilder: (context, index) {
        final String imagePath = widget.product.images[index];

        // Determine if it's an asset or network image
        final bool isAsset = imagePath.startsWith('asset://');
        final ImageSource source =
            isAsset ? ImageSource.asset : ImageSource.network;
        final String path =
            isAsset ? imagePath.replaceFirst('asset://', '') : imagePath;

        return UniversalCachedImage(
          imagePath: path,
          source: source,
          fit: BoxFit.cover,
          errorWidget: _buildErrorWidget(context),
        );
      },
    );
  }

  Widget _buildEmptyGallery(BuildContext context) {
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

  Widget _buildErrorWidget(BuildContext context) {
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
  }
}
