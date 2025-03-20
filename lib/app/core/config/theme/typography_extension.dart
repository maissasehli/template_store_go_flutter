import 'package:flutter/material.dart';
import 'package:store_go/app/core/config/theme/typography.dart';

class AppTypographyExtension extends ThemeExtension<AppTypographyExtension> {
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle h4;
  final TextStyle h5;
  final TextStyle subtitle1;
  final TextStyle subtitle2;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle buttonText;
  final TextStyle caption;
  final TextStyle overline;

  AppTypographyExtension({
    required this.h1,
    required this.h2,
    required this.h3,
    required this.h4,
    required this.h5,
    required this.subtitle1,
    required this.subtitle2,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.buttonText,
    required this.caption,
    required this.overline,
  });

  @override
  ThemeExtension<AppTypographyExtension> copyWith({
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? h4,
    TextStyle? h5,
    TextStyle? subtitle1,
    TextStyle? subtitle2,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? buttonText,
    TextStyle? caption,
    TextStyle? overline,
  }) {
    return AppTypographyExtension(
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      h4: h4 ?? this.h4,
      h5: h5 ?? this.h5,
      subtitle1: subtitle1 ?? this.subtitle1,
      subtitle2: subtitle2 ?? this.subtitle2,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      buttonText: buttonText ?? this.buttonText,
      caption: caption ?? this.caption,
      overline: overline ?? this.overline,
    );
  }

  @override
  ThemeExtension<AppTypographyExtension> lerp(
    covariant ThemeExtension<AppTypographyExtension>? other,
    double t,
  ) {
    if (other is! AppTypographyExtension) {
      return this;
    }

    return AppTypographyExtension(
      h1: TextStyle.lerp(h1, other.h1, t)!,
      h2: TextStyle.lerp(h2, other.h2, t)!,
      h3: TextStyle.lerp(h3, other.h3, t)!,
      h4: TextStyle.lerp(h4, other.h4, t)!,
      h5: TextStyle.lerp(h5, other.h5, t)!,
      subtitle1: TextStyle.lerp(subtitle1, other.subtitle1, t)!,
      subtitle2: TextStyle.lerp(subtitle2, other.subtitle2, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      buttonText: TextStyle.lerp(buttonText, other.buttonText, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      overline: TextStyle.lerp(overline, other.overline, t)!,
    );
  }

  // Helper method to create from AppTextStylesData
  static AppTypographyExtension fromAppTextStylesData(AppTextStylesData styles) {
    return AppTypographyExtension(
      h1: styles.h1,
      h2: styles.h2,
      h3: styles.h3,
      h4: styles.h4,
      h5: styles.h5,
      subtitle1: styles.subtitle1,
      subtitle2: styles.subtitle2,
      bodyLarge: styles.bodyLarge,
      bodyMedium: styles.bodyMedium,
      bodySmall: styles.bodySmall,
      buttonText: styles.buttonText,
      caption: styles.caption,
      overline: styles.overline,
    );
  }
}
