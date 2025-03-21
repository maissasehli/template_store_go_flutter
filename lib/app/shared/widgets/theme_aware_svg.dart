import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/theme/app_color_utils.dart';

class ThemeAwareSvg extends StatelessWidget {
  /// The asset path to the SVG file
  final String assetPath;

  /// Optional width of the SVG (defaults to 24)
  final double? width;

  /// Optional height of the SVG (defaults to 24)
  final double? height;

  /// Optional color name from the theme to apply to the SVG
  /// Uses the AppColorName enum for type safety
  final AppColorName? colorName;

  /// Whether to only apply the color to filled areas (default: true)
  final bool onlyFill;

  const ThemeAwareSvg({
    super.key,
    required this.assetPath,
    this.width = 24,
    this.height = 24,
    this.colorName,
    this.onlyFill = true,
  });

  @override
  Widget build(BuildContext context) {
    // Get the theme color based on the provided color name
    // If no colorName is provided, fall back to the primary color
    final themeColor =
        colorName != null
            ? AppColorUtils.getThemeColor(context, colorName!)
            : Theme.of(context).colorScheme.primary;

    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      colorFilter:
          onlyFill ? ColorFilter.mode(themeColor, BlendMode.srcIn) : null,
    );
  }
}
