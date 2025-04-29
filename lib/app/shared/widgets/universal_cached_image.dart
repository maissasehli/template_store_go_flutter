import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/services/enhanced_image_cache.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

enum ImageSource { asset, network }
enum ImageType { raster, svg }

class UniversalCachedImage extends StatefulWidget {
  final String imagePath;
  final ImageSource source;
  final ImageType type;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? color;
  final BlendMode? colorBlendMode;
  final BorderRadius? borderRadius;
  final bool useShimmerEffect;

  const UniversalCachedImage({
    super.key,
    required this.imagePath,
    required this.source,
    this.type = ImageType.raster, // Default to raster image
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.color,
    this.colorBlendMode,
    this.borderRadius,
    this.useShimmerEffect = true,
  });

  @override
  State<UniversalCachedImage> createState() => _UniversalCachedImageState();
}

class _UniversalCachedImageState extends State<UniversalCachedImage> {
  final EnhancedImageCache _cacheService = Get.find<EnhancedImageCache>();
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    if (widget.type == ImageType.raster) {
      _loadImage();
    } else {
      // SVG doesn't need preloading in the same way
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadImage() async {
    if (widget.type == ImageType.svg) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final isAsset = widget.source == ImageSource.asset;

    // Check if already cached
    if (_cacheService.isImageCached(widget.imagePath, isAsset: isAsset)) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      if (isAsset) {
        await _cacheService.cacheAssetImage(context, widget.imagePath);
      } else {
        await _cacheService.cacheNetworkImage(widget.imagePath);
      }

      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('Error loading image ${widget.imagePath}: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show error widget if there was an error
    if (_hasError) {
      return _buildErrorWidget(context);
    }

    // Show loading placeholder if still loading
    if (_isLoading) {
      return _buildLoadingWidget(context);
    }

    // Build the appropriate image widget based on type
    Widget imageWidget;
    
    if (widget.type == ImageType.svg) {
      if (widget.source == ImageSource.asset) {
        imageWidget = SvgPicture.asset(
          widget.imagePath,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          colorFilter: widget.color != null 
            ? ColorFilter.mode(widget.color!, widget.colorBlendMode ?? BlendMode.srcIn)
            : null,
        );
      } else {
        imageWidget = SvgPicture.network(
          widget.imagePath,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          colorFilter: widget.color != null 
            ? ColorFilter.mode(widget.color!, widget.colorBlendMode ?? BlendMode.srcIn)
            : null,
          placeholderBuilder: (context) => _buildLoadingWidget(context),
        );
      }
    } else {
      // Raster image handling with existing cache service
      imageWidget = Image(
        image: _cacheService.getImageProvider(
          widget.imagePath,
          isAsset: widget.source == ImageSource.asset,
        ),
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        color: widget.color,
        colorBlendMode: widget.colorBlendMode,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget(context);
        },
      );
    }

    // Apply border radius if specified
    if (widget.borderRadius != null) {
      return ClipRRect(borderRadius: widget.borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildLoadingWidget(BuildContext context) {
    // Custom placeholder provided
    if (widget.placeholder != null) {
      return widget.placeholder!;
    }

    // Default loading placeholder with shimmer effect
    final container = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.muted(context),
        borderRadius: widget.borderRadius,
      ),
    );

    // Apply shimmer effect if enabled
    if (widget.useShimmerEffect) {
      return Shimmer.fromColors(
        baseColor: AppColors.muted(context),
        highlightColor: AppColors.background(context),
        child: container,
      );
    }

    return container;
  }

  Widget _buildErrorWidget(BuildContext context) {
    if (widget.errorWidget != null) {
      return widget.errorWidget!;
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.muted(context),
        borderRadius: widget.borderRadius,
      ),
      child: Center(
        child: Icon(
          Icons.broken_image,
          color: AppColors.mutedForeground(context),
          size: (widget.width ?? 100) * 0.4,
        ),
      ),
    );
  }
}