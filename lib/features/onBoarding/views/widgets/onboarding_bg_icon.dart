import 'package:flutter/material.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/shared/widgets/universal_cached_image.dart';
class OnBoardingBgIcon extends StatelessWidget {
  final double? bottom;
  final double? top;
  final double? left;
  final double? right;
  final double size;
  final double rotationAngle;
  final double opacity;  // Add opacity parameter

  const OnBoardingBgIcon({
    super.key,
    this.bottom,
    this.top,
    this.left,
    this.right,
    required this.size,
    this.rotationAngle = 0,
    this.opacity = 0.21,  // Default to 21% opacity as shown in your images
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      top: top,
      left: left,
      right: right,
      child: Transform.rotate(
        angle: rotationAngle * 3.14159 / 180,
        child: UniversalCachedImage(
          imagePath: AssetConfig.onBoardingIconBag,
          source: ImageSource.asset,
          type: ImageType.svg,
          width: size,
          height: size,
          color: const Color(0xFF717171).withOpacity(opacity),  
          colorBlendMode: BlendMode.srcIn,  
          fit: BoxFit.contain,
        ),
      ),
    );
  }

}