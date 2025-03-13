import 'package:flutter/material.dart';
import 'package:store_go/core/theme/color_extension.dart';
import 'package:store_go/view/widgets/ui/cached_asset_image.dart';

class OnboardingCarouselImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final EdgeInsets? margin;

  const OnboardingCarouselImage({
    super.key,
    required this.imagePath,
    required this.width,
    required this.height,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorExtension>();
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: CachedAssetImage(
          imagePath: imagePath,
          width: width,
          height: height,
          fit: BoxFit.cover,
          placeholder: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: colors?.muted ?? Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ),
    );
  }
}
