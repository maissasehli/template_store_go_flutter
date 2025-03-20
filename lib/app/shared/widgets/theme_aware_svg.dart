import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThemeAwareSvg extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;
  final bool onlyFill;

  const ThemeAwareSvg({
    super.key,
    required this.assetPath,
    this.width = 24,
    this.height = 24,
    this.color,
    this.onlyFill = false,
  });

  @override
  Widget build(BuildContext context) {
    // Use the primary color from the theme if no specific color is provided
    final themeColor = color ?? Theme.of(context).colorScheme.primary;

    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      colorFilter: onlyFill
          ? ColorFilter.mode(themeColor, BlendMode.srcIn)
          : null,
    );
  }
}
