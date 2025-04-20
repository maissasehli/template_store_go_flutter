import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

class ImagePageIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalImages;

  const ImagePageIndicator({
    super.key,
    required this.currentIndex,
    required this.totalImages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalImages,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                index == currentIndex
                    ? AppColors.foreground(context)
                    : AppColors.border(context),
          ),
        ),
      ),
    );
  }
}
