import 'dart:async';

import 'package:flutter/material.dart';

// A simple skeleton widget with shimmer effect
class ShimmerSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerSkeleton({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = 16.0,
  }) : super(key: key);

  @override
  State<ShimmerSkeleton> createState() => _ShimmerSkeletonState();
}

class _ShimmerSkeletonState extends State<ShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Calculate gradient position based on animation value
        final double shimmerValue = _controller.value;
        
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.grey[800], // Base dark gray color
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * shimmerValue, 0.0),
              end: Alignment(1.0 + 2.0 * shimmerValue, 0.0),
              colors: [
                Colors.grey[800]!,
                Colors.grey[600]!,
                Colors.grey[800]!,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

// A wrapper widget that shows either skeleton or image
class ImageWithSkeleton extends StatefulWidget {
  final String imagePath;
  final double width;
  final double height;
  final bool isAsset;
  final double borderRadius;

  const ImageWithSkeleton({
    Key? key,
    required this.imagePath,
    required this.width,
    required this.height,
    this.isAsset = true,
    this.borderRadius = 16.0,
  }) : super(key: key);

  @override
  State<ImageWithSkeleton> createState() => _ImageWithSkeletonState();
}

class _ImageWithSkeletonState extends State<ImageWithSkeleton> {
  bool _isLoaded = false;
  bool _isLoading = false;
  late ImageProvider _imageProvider;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (_isLoading) return;
    _isLoading = true;

    // Create the image provider
    _imageProvider = widget.isAsset 
        ? AssetImage(widget.imagePath)
        : NetworkImage(widget.imagePath) as ImageProvider;

    // Wait a moment to show skeleton (for demo purposes)
    await Future.delayed(const Duration(seconds: 2));

    // Preload the image
    final ImageStream stream = _imageProvider.resolve(ImageConfiguration.empty);
    final completer = Completer<void>();
    
    final listener = ImageStreamListener(
      (info, synchronousCall) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
      onError: (exception, stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(exception);
        }
      },
    );

    stream.addListener(listener);
    
    try {
      await completer.future;
      if (mounted) {
        setState(() {
          _isLoaded = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('Error loading image: $e');
    } finally {
      stream.removeListener(listener);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          image: DecorationImage(
            image: _imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return ShimmerSkeleton(
        width: widget.width,
        height: widget.height,
        borderRadius: widget.borderRadius,
      );
    }
  }
}

// A simple carousel with skeleton placeholders
class OnboardingImageCarousel extends StatelessWidget {
  final String mainImage;
  final String leftImage;
  final String rightImage;
  
  const OnboardingImageCarousel({
    Key? key,
    required this.mainImage,
    required this.leftImage,
    required this.rightImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the screen width to calculate image dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double mainImageWidth = screenWidth * 0.80;
    double sideImageWidth = screenWidth * 0.16;
    double sideImageHeight = 210.0;
    double mainImageHeight = 230.0;

    return SizedBox(
      height: mainImageHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Left image (partially visible)
          Positioned(
            left: -screenWidth * 0.1,
            child: ImageWithSkeleton(
              imagePath: leftImage,
              width: sideImageWidth,
              height: sideImageHeight,
            ),
          ),
          // Right image (partially visible)
          Positioned(
            right: -screenWidth * 0.1,
            child: ImageWithSkeleton(
              imagePath: rightImage,
              width: sideImageWidth,
              height: sideImageHeight,
            ),
          ),
          // Main image (centered)
          Center(
            child: ImageWithSkeleton(
              imagePath: mainImage,
              width: mainImageWidth,
              height: mainImageHeight,
            ),
          ),
        ],
      ),
    );
  }
}