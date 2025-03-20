import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/services/image_cache.dart';

class CachedAssetImage extends StatefulWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Color? color;
  final BlendMode? colorBlendMode;

  const CachedAssetImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.fill,
    this.placeholder,
    this.color,
    this.colorBlendMode,
  });

  @override
  State<CachedAssetImage> createState() => _CachedAssetImageState();
}

class _CachedAssetImageState extends State<CachedAssetImage> {
  final ImageCacheService _cacheService = Get.find<ImageCacheService>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (_cacheService.isImageCached(widget.imagePath)) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    await _cacheService.cacheImage(context, widget.imagePath);

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && widget.placeholder != null) {
      return widget.placeholder!;
    }

    return Image(
      image: _cacheService.getImageProvider(widget.imagePath),
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      color: widget.color,
      colorBlendMode: widget.colorBlendMode,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame != null || wasSynchronouslyLoaded) {
          return child;
        }
        return widget.placeholder ??
            SizedBox(width: widget.width, height: widget.height);
      },
    );
  }
}
