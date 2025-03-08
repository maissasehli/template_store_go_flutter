import 'package:flutter/material.dart';

class AppTypography {
  // Font families
  static const String primaryFont = 'Inter';
  static const String secondaryFont = 'Poppins';

  // Font weights
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // Line heights
  static const double lineHeightTight = 1.1;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.8;

  // Letter spacing
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.5;
}

// Define text style data structure
class AppTextStylesData {
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

  const AppTextStylesData({
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
}
