import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_color_extension.dart';
import 'package:store_go/app/shared/widgets/universal_cached_image.dart';

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
      child: UniversalCachedImage(
        imagePath: imagePath,
        source: ImageSource.asset,
        width: width,
        height: height,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(20.0),
        placeholder: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: colors?.muted ?? Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
